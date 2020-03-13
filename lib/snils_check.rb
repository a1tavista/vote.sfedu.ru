class SnilsCheck
  # New object with SNILS +number+ if provided.
  def initialize(number = nil)
    @snils = if number.kind_of?(Numeric)
               '%011d' % number
             elsif number.present?
               number.to_s.gsub(/[^\d]/, '')
             end
    @snils ||= ''

    @errors = []
    @validated = false
  end

  # Calculates checksum (last 2 digits) of a number
  def checksum
    digits = @snils.split('').take(9).map(&:to_i)
    checksum = digits.each.with_index.reduce(0) do |sum, (digit, index)|
      sum + digit * (9 - index)
    end
    while checksum > 101 do
      checksum = checksum % 101
    end
    checksum = 0  if (100..101).include?(checksum)
    '%02d' % checksum
  end

  # Validates SNILS. Valid SNILS is a 11 digits long and have correct checksum
  def valid?
    validate unless @validated
    @errors.none?
  end

  # Validates string with a SNILS. Valid SNILS is a 11 digits long and have correct checksum.
  def self.valid?(snils)
    self.new(snils).valid?
  end

  # Returns SNILS in format 000-000-000 00
  def formatted
    "#{@snils[0..2]}-#{@snils[3..5]}-#{@snils[6..8]} #{@snils[9..10]}"
  end

  # Returns unformatted SNILS (only 11 digits)
  def raw
    @snils
  end
  alias_method :to_s, :raw

  def encrypt
    return nil if @snils.blank?
    Digest::SHA1.hexdigest(@snils)
  end

  # Returns array with errors if SNILS invalid
  def errors
    validate unless @validated
    @errors
  end

  protected

  def validate
    @errors << [:wrong_length, { :count => 11 }] if @snils.blank? || @snils.length != 11
    @errors << :invalid if @snils.present? && @snils[-2..-1] != self.checksum
    @validated = true
  end

end
