class User < ApplicationRecord
  # devise :openid_authenticatable, :rememberable, :trackable
  devise :rememberable, :trackable

  belongs_to :kind, polymorphic: true

  enum role: [:regular, :moderator, :admin]
  attr_accessor :identity_name

  def self.build_identity_url(url)
    "https://openid.sfedu.ru/server.php/idpage?user=#{url}"
  end

  def self.build_from_identity_url(identity_url)
    self.new(identity_url: identity_url)
  end

  def self.openid_optional_fields
    %w(email nickname r61globalkey r61recoverymail r61studentid staff student)
  end

  def openid_fields=(fields)
    self.email = fields.fetch('email')
    self.nickname = fields.fetch('nickname')
    self.kind ||= if fields.fetch['student'] == 1
                    Student.find_or_create_by(external_id: fields.fetch('r61studentid'))
                  else
                    Teacher.find_or_create_by(external_id: fields.fetch('r61globalkey'))
                  end
  end
end
