# frozen_string_literal: true

# Mostly copied and pasted from https://github.com/mlibrary/oidc_omniauth_demo

require 'omniauth'
require 'omniauth_openid_connect'

enable :sessions
set :session_secret, ENV.fetch('RACK_SESSION_SECRET', nil)

use OmniAuth::Builder do
  provider :openid_connect, {
    issuer: ENV.fetch('OIDC_ISSUER', nil),
    discovery: true,
    client_auth_method: 'query',
    scope: %i[openid profile email],
    client_options: {
      identifier: ENV.fetch('OIDC_CLIENT_ID', nil),
      secret: ENV.fetch('OIDC_CLIENT_SECRET', nil),
      redirect_uri: ENV.fetch('OIDC_REDIRECT_URI', nil) || 'http://localhost:4567/auth/openid_connect/callback'
    }
  }
end

get '/auth/openid_connect/callback' do
  auth = request.env['omniauth.auth']
  info = auth[:info]
  session[:authenticated] = true
  session[:expires_at] = Time.now.utc + 1.hour
  session[:info] = info
  redirect '/'
end

get '/auth/failure' do
  'You are not authorized'
end

get '/login' do
  <<~HTML
    <!DOCTYPE html>
    <head>
      <script>
        window.onload = function(){
          document.forms['login_form'].submit();
        }
      </script>
    </head>
    <body>
      <h1>Logging You In...<h1>
      <form id="login_form" method="post" action="/auth/openid_connect">
        <input type="hidden" name="authenticity_token" value="#{request.env['rack.session']['csrf']}">
        <noscript>
          <button type="submit">Login</button>
        </noscript>
      </form>
    </body>
  HTML
end

def authorize!
  halt 403 unless Services.users.include? session.fetch('info')&.fetch('email')
end

before do
  # pass if the first part of the path is exempted from authentication;
  # in this case any paths under 'auth' should be exempted
  pass if %w[auth login].include? request.path_info.split('/')[1]

  if !session[:authenticated] || Time.now.utc > session[:expires_at]
    redirect '/login'
  else
    authorize!
  end
end
