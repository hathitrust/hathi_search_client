# frozen_string_literal: true

require 'sinatra'

def authenticate!
  halt 403 unless request.get_header('HTTP_X_REMOTE_USER') == 'jstever@umich.edu'
end

before do
  authenticate!
end

get '/' do
  #'hello world!'
  s = Search.new(%w[author publisher], ['Australian National University', 'ANU'])
  "# results : #{s.records.count}"
end
