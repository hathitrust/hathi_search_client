# frozen_string_literal: true

$LOAD_PATH << './lib'
require 'sinatra'

require 'query'
require 'search'
require 'time'
require 'authn_authz'

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
