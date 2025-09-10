# config/initializers/omniauth.rb

require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  scopes = [
    "user-read-email",
    "playlist-modify-private",
    "playlist-modify-public",
    "playlist-read-private",
    "playlist-read-collaborative",
    "user-library-read",
    "user-library-modify",
    "user-follow-read"
  ]
  provider :spotify, "b0969ab732d74d4b86f84ed01ac31199", "45e861a0386b47139ee20cc2ff43e65d", scope: scopes.join(' ')
end

OmniAuth.config.allowed_request_methods = [:post, :get]
