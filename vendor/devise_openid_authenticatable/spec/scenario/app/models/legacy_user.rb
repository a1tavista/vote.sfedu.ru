class LegacyUser < ActiveRecord::Base
  devise :openid_authenticatable, :rememberable

  def self.create_from_identity_url(identity_url)
    create do |user|
      user.identity_url = identity_url
    end
  end

  def self.openid_required_fields
    ["http://axschema.org/contact/email"]
  end

  def openid_fields=(fields)
    self.email = fields["http://axschema.org/contact/email"].first
  end

end