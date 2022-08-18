# frozen_string_literal: true

$LOAD_PATH << "./lib"
require "sinatra"

require "query"
require "search"
require "time"
require "authn_authz"

def tsv_results
  content_type("text/plain")
  attachment(Time.now.strftime("results_%Y-%m-%d_%s.tsv"))
  stream do |res|
    res << erb(:search_results_header)
    @s.records_to_tsv.each do |rec|
      res << rec << "\n"
    end
  end
end

def construct_search
  @indexes = params[:indexes] || []
  @terms = (params[:terms] || []).reject { |t| t == "" }
  if @indexes.any? && @terms.any?
    @indexes << "author2" if @indexes.include? "author"
    @s = Search.new(@indexes, @terms)
  end
end

get "/" do
  construct_search

  if params[:results] == "Get TSV"
    tsv_results
  else
    erb :search_form
  end
end
