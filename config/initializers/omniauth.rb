Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    access_type: "offline",
    approval_prompt: "force",
    prompt: "select_account consent",
    provider_ignores_state: true,
    scope: "email,profile,calendar",
    skip_jwt: true
  }

  provider :facebook, ENV["FACEBOOK_CLIENT_ID"], ENV["FACEBOOK_CLIENT_SECRET"],
    client_options: {
      :site => 'https://graph.facebook.com/v2.0',
      :authorize_url => "https://www.facebook.com/v2.0/dialog/oauth"
    },
    scope: 'email,public_profile',
    display: 'popup'

  on_failure { |env|
    env['devise.mapping'] = Devise.mappings[:user]
    Users::OmniauthCallbacksController.action(:failure).call(env)
  }
end
