# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env')
require 'net/http'

class SolrCatalog
  attr_accessor :solr

  def initialize
    host = ENV['SOLR_HOST'] || 'solr-catalog'
    port = ENV['SOLR_PORT'] || '9033'
    @solr = Net::HTTP.new(host, port)
  end
end
