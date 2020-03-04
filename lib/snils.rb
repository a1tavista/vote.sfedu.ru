module Snils
  def self.normalize(raw_snils)
    return nil if raw_snils.nil?
    normalized_snils = raw_snils.gsub(' ', '').gsub('-', '')
    normalized_snils.presence
  end

  def self.encrypt(normalized_snils)
    return nil if normalized_snils.nil?
    Digest::SHA1.hexdigest(normalized_snils)
  end
end
