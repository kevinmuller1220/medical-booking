class Identity < ActiveRecord::Base
  belongs_to :user

  def self.find_with_omniauth(auth)
    identity = find_by(uid: auth['uid'], provider: auth['provider'])
    if identity.present?
      puts auth.credentials.expires_at
      identity.update_attributes!(
        token: auth.credentials.token,
        expires_at: Time.at(auth.credentials.expires_at)
      )
    end
    identity
  end

  def self.find_with_provider(provider)
    find_by(provider: provider)
  end

  def self.create_with_omniauth(auth)
    create(
      uid: auth['uid'], provider: auth['provider'],
      token: auth.credentials.token, expires_at: auth.credentials.expires_at,
      first_name: auth.info.first_name, last_name: auth.info.last_name,
      email: auth.info.email, image: auth.info.image
    )
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def token_expired?
    expiry = Time.at(self.expires_at)
    return true if expiry < Time.now # expired token, so we should quickly return
    false # token not expired.
  end
end
