# frozen_string_literal: true

require 'json'
require 'ht_item'
require 'marc'

class CatalogRecord
  attr_accessor :zephir_cid, :title, :authors, :publisher, :title_pub_date, :ht_items, :subject, :rec_src_code

  def initialize(**attributes)
    attributes.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def self.new_from_doc(doc)
    rec = { zephir_cid: doc['id'],
            rec_src_code: rec_src_code(doc),
            title: doc['title'].first,
            authors: doc['author'] || [],
            publisher: doc['publisher'] || [],
            title_pub_date: doc['publishDate'],
            subject: doc['topicStr'],
            ht_items: ht_items_from_json(doc['ht_json']) }
    new(rec)
  end

  def self.ht_items_from_json(ht_json)
    @ht_items = []
    JSON.parse(ht_json).each do |item|
      @ht_items << HTItem.new(item)
    end
    @ht_items
  end

  def self.rec_src_code(doc)
    return '' unless doc['fullrecord']

    marc = MARC::XMLReader.new(StringIO.new(doc['fullrecord'])).first
    marc['HOL']['s'] || ''
  end
end
