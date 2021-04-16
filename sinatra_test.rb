# frozen_string_literal: true

require 'sinatra'

def authenticate!
  halt 403 unless request.get_header('HTTP_X_REMOTE_USER') == 'admin@default.invalid'
end

before do
  #authenticate!
end

get '/' do
  erb :search_form 
end
