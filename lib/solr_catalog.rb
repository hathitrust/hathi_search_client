# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env')
require 'net/http'

class SolrCatalog
  attr_accessor :solr

  def initialize
    host = ENV.fetch('SOLR_HOST', nil) || 'solr-catalog'
    port = ENV.fetch('SOLR_PORT', nil) || '9033'
    @solr = Net::HTTP.new(host, port)
    @solr.read_timeout = 120
  end
end
