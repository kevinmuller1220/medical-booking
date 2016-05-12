class Identity < ActiveRecord::Base
  belongs_to :user

  def self.find_with_omniauth(auth)
    identity = find_by(uid: auth['uid'], provider: auth['provider'])
    if identity.present?
      puts auth.credentials.expires_at
      identity.update_attributes!(
        token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token,
        expires_at: Time.at(auth.credentials.expires_at)
      )
    end
    identity
  end

  def self.find_with_provider(provider)
    identity = find_by(provider: provider)
    if identity.token_expired?
      if provider == 'google_oauth2'
        identity.refresh_google_token
      end
    end
    identity
  end

  def self.create_with_omniauth(auth)
    create(
      uid: auth['uid'], provider: auth['provider'],
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      expires_at: auth.credentials.expires_at,
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

  def refresh_google_token
    client = Signet::OAuth2::Client.new(
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token',
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      access_token: self.token,
      refresh_token: self.refresh_token
    )
    client.refresh!
    if client.access_token.present?
      update_attributes!(
        token: client.access_token
      )
    else
      # No Token
    end
  rescue
    # Something else bad happened
  end
end
