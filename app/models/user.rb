class User < ApplicationRecord
  devise :openid_authenticatable, :rememberable, :trackable
  belongs_to :kind, polymorphic: true

  enum role: %i[regular moderator admin]

  attr_accessor :identity_name
  after_create { publish_event(Events::RegisteredNewUser) }

  def self.build_identity_url(url)
    "https://openid.sfedu.ru/server.php/idpage?user=#{url&.downcase}"
  end

  def self.build_from_identity_url(identity_url)
    new(identity_url: identity_url&.downcase)
  end

  def self.find_by_identity_url(identity_url)
    user = find_by(identity_url: identity_url&.downcase)
    user.publish_event(Events::UserAuthenticated) if user.present?
    user
  end

  def self.openid_optional_fields
    %w[email nickname r61globalkey r61studentid student staff]
  end

  def openid_fields=(fields)
    self.email = fields.fetch("email").downcase
    self.nickname = fields.fetch("nickname").downcase

    if fields.fetch("student") == "1"
      id = normalize_id(fields.fetch("r61studentid"))
      self.kind = Student.find_or_create_by(external_id: id)
    else
      id = normalize_id(fields.fetch("r61globalkey"))
      self.kind = Teacher.find_or_create_by(external_id: id)
    end
  end

  def publish_event(klass, data = {})
    data = data.merge(user_id: id)
    event = klass.new(data: data)
    event_store.publish(event, stream_name: stream_name)
  end

  def stream_name
    ["User", id].join(":")
  end

  def student?
    kind.is_a?(Student)
  end

  def teacher?
    kind.is_a?(Teacher)
  end

  def normalize_id(raw_id)
    raw_id.gsub(/[^0-9]/, "").rjust(9, "0")
  end
end
