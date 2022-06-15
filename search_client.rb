# frozen_string_literal: true

$LOAD_PATH << './lib'
require 'sinatra'

require 'omniauth'
require 'omniauth_openid_connect'
require 'query'
require 'search'
require 'time'

enable :sessions
set :session_secret, ENV['RACK_SESSION_SECRET']

require 'auth'

get '/' do
  @indexes = params[:indexes] || []
  @terms = (params[:terms] || []).reject { |t| t == '' }
  if @indexes.any? && @terms.any?
    @indexes << 'author2' if @indexes.include? 'author'
    @s = Search.new(@indexes, @terms)
  end
  if params[:results] == 'Get TSV'
    content_type('text/plain')
    attachment(Time.now.strftime('results_%Y-%m-%d_%s.tsv'))
    erb :search_results
  else
    erb :search_form
  end
end
