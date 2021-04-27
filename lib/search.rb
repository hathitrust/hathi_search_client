# frozen_string_literal: true

require 'dotenv'
require 'query'
require 'pry'
require 'uri'
require 'catalog_record'
require 'json'
require 'services'

class Search
  attr_accessor :indexes, :terms, :page, :page_size, :fields, :query

  Dotenv.load

  def initialize(indexes, terms)
    @fields = 'id,ht_json,fullrecord,sdrnum,title,author,publishDate,publisher,topicStr'
    @indexes = indexes
    @terms = terms
    @page = 0
    @page_size = 100_000
    @query = Query.new(@indexes, @terms)
  end

  def search_uri(num_rows = page_size)
    base = '/solr/catalog/select?'
    enum = [['q', @query.to_str],
            ['rows', num_rows],
            ['start', page_start],
            %w[wt json],
            ['json.nl', 'arrarr'],
            ['fl', fields]]
    base + URI.encode_www_form(enum)
  end

  def page_start
    @page * @page_size
  end

  def num_results
    return @num_results unless @num_results.nil?

    response = JSON.parse(Services.solr_catalog.get(search_uri(0)).body)
    @num_results = response['response']['numFound']
  end

  def records
    return @records unless @records.nil?

    @records = []
    while num_results > page_start
      response = JSON.parse(Services.solr_catalog.get(search_uri).body)
      response['response']['docs'].map { |doc| @records << CatalogRecord.new_from_doc(doc) }
      @page += 1
    end
    @records
  end

  def header
    %w[Zephir_CID
       title
       authors
       publisher
       title_pub_date
       ht_id
       item_pub_date
       enum_chron
       rights
       reason].join("\t")
  end

  def records_to_tsv
    return to_enum(:records_to_tsv) unless block_given?

    records.each do |rec|
      rec.ht_items.each do |ht_item|
        yield [rec.zephir_cid,
               rec.title,
               rec.authors.join('; '),
               rec.publisher.join('; '),
               rec.title_pub_date,
               ht_item.ht_id,
               ht_item.pub_date,
               ht_item.enum_chron,
               ht_item.rights_attribute,
               ht_item.rights_reason].join("\t")
      end
    end
  end
end
