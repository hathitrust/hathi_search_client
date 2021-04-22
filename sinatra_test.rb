# frozen_string_literal: true

$LOAD_PATH << './lib'
require 'sinatra'

require 'query'
require 'search'
require 'pp'

def authenticate!
  halt 403 unless request.get_header('HTTP_X_REMOTE_USER') == 'jstever@umich.edu'
end

before do
  authenticate!
end

get '/search-client' do
  @indexes = params[:indexes] || []
  @terms = (params[:terms] || []).reject {|t| t == ''}
  if @indexes.any? and @terms.any?
    @indexes << "author2" if @indexes.include? "author"
    @s = Search.new(@indexes, @terms)
  end
  PP.pp ENV
  erb :search_form 
end
