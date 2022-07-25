# frozen_string_literal: true

require "dotenv"
require "query"
require "pry"
require "uri"
require "catalog_record"
require "json"
require "services"
require "solr/cursorstream"

class Search
  attr_accessor :indexes, :terms, :page, :page_size, :fields, :query
  attr_writer :records

  Dotenv.load

  def initialize(indexes, terms)
    @fields = "id,ht_json,fullrecord,sdrnum,title,author,publishDate,publisher,topic"
    @indexes = indexes
    @terms = terms
    @page = 0
    @page_size = 100_000
    @query = Query.new(@indexes, @terms)
  end

  def num_results
    return @num_results unless @num_results.nil?

    response = JSON.parse(Services.solr_catalog.get(search_uri).body)
    @num_results = response["response"]["numFound"]
  end

  def header
    %w[Zephir_CID
      rec_src_code
      title
      authors
      publisher
      title_pub_date
      subject
      ht_id
      item_pub_date
      enum_chron
      rights
      reason].join("\t")
  end

  def records_to_tsv
    return to_enum(:records_to_tsv) unless block_given?

    cs = Solr::CursorStream.new(url: SolrCatalog.new.core_url)
    cs.fields = fields
    cs.query = query.to_str
    cs.each do |doc|
      rec = CatalogRecord.new_from_doc(doc)
      rec.ht_items.each do |ht_item|
        yield [rec.zephir_cid,
          rec.rec_src_code,
          rec.title,
          rec.authors.join("; "),
          rec.publisher.join("; "),
          rec.title_pub_date,
          rec.subject.join("; "),
          ht_item.ht_id,
          ht_item.pub_date,
          ht_item.enum_chron,
          ht_item.rights_attribute,
          ht_item.rights_reason].join("\t")
      end
    end
  end

  private

  # Only used by num_results
  def search_uri
    base = "/solr/catalog/select?"
    enum = [["q", @query.to_str],
      ["rows", 10],
      ["start", 0],
      %w[wt json],
      ["json.nl", "arrarr"],
      ["fl", fields]]
    base + URI.encode_www_form(enum)
  end
end
