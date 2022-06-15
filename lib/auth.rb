# Mostly copied and pasted from https://github.com/mlibrary/oidc_omniauth_demo

use OmniAuth::Builder do
  provider :openid_connect, {
    issuer: ENV['OIDC_ISSUER'],
    discovery: true,
    client_auth_method: 'query',
    scope: [:openid, :profile, :email],
    client_options: {
      identifier: ENV['OIDC_CLIENT_ID'],
      secret: ENV['OIDC_CLIENT_SECRET'],
      # TODO calculate from env?
      redirect_uri: ENV['OIDC_REDIRECT_URI'] || "http://localhost:4567/auth/openid_connect/callback"
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
  "You are not authorized"
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
        <input type="hidden" name="authenticity_token" value="#{request.env["rack.session"]["csrf"]}">
        <noscript>
          <button type="submit">Login</button>
        </noscript>
      </form>
    </body>
  HTML
end

before  do
  #pass if the first part of the path is exempted from authentication;
  #in this case any paths under 'auth' should be exempted
  pass if ['auth','login'].include? request.path_info.split('/')[1]

  if !session[:authenticated] || Time.now.utc > session[:expires_at]
    redirect '/login'
  else
    pass
  end

end
