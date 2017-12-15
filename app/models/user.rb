class User < ApplicationRecord
  devise :openid_authenticatable, :rememberable, :trackable
  belongs_to :kind, polymorphic: true, dependent: :destroy

  enum role: %i(regular moderator admin)

  attr_accessor :identity_name

  def self.build_identity_url(url)
    "https://openid.sfedu.ru/server.php/idpage?user=#{url}"
  end

  def self.build_from_identity_url(identity_url)
    new(identity_url: identity_url)
  end

  def self.openid_optional_fields
    %w(email nickname r61globalkey r61studentid student staff)
  end

  def openid_fields=(fields)
    self.email = fields.fetch('email')
    self.nickname = fields.fetch('nickname')

    if fields.fetch('student') == '1'
      id = normalize_id(fields.fetch('r61studentid'))
      self.kind = Student.find_or_create_by(external_id: id)
    else
      id = normalize_id(fields.fetch('r61globalkey'))
      self.kind = Teacher.find_or_create_by(external_id: id)
    end
  end

  def student?
    self.kind.is_a?(Student)
  end

  def teacher?
    self.kind.is_a?(Teacher)
  end

  def normalize_id(raw_id)
    raw_id.gsub(/[^0-9]/, '').rjust(9, '0')
  end
end
