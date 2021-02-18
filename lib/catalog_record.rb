# frozen_string_literal: true

require 'json'
require 'ht_item'
require 'pp'

class CatalogRecord
  attr_accessor :zephir_cid, :title, :authors, :publisher, :title_pub_date, :ht_items

  def initialize(**attributes)
    attributes.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def self.new_from_doc(doc)
    rec = { zephir_cid: doc['id'],
            title: doc['title'].first,
            authors: doc['author'] || [],
            publisher: doc['publisher'] || [],
            title_pub_date: doc['publishDate'],
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
end
