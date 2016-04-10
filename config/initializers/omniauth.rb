Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "320531325879-o3qje4ahq97v1164b0h9li0o6ol783s5.apps.googleusercontent.com", "9EzmVgwOBbZx_oynux2TxaMr", {
    access_type: "offline",
    approval_prompt: "",
    provider_ignores_state: true,
    scope: 'profile,email,calendar',
    skip_jwt: true
  }

  provider :facebook, "1680177442238628", "a80dd492dea78d910dc0b566591b6b2f",
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
