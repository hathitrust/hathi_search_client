# frozen_string_literal: true

require 'sinatra'

def authenticate!
  halt 403 unless request.get_header('HTTP_X_REMOTE_USER') == 'jstever@umich.edu'
end

before do
  #authenticate!
end

get '/search-client' do
  #'hello world!'
  remote_user = request.get_header('HTTP_X_REMOTE_USER')
  "remote user: #{remote_user}"
  #s = Search.new(%w[author publisher], ['Australian National University', 'ANU'])
  #"# results : #{s.records.count}"
end
