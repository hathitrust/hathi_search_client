# frozen_string_literal: true

require 'services'

class HTItem
  attr_accessor :ht_id, :rights, :enum_chron, :pub_date, :rights_attribute, :rights_reason

  def initialize(solr_item)
    @ht_id = solr_item['htid']
    @enum_chron = solr_item['enumcron'] || ''
    @pub_date = solr_item['enum_pubdate'] || ''
    @rights = Services.rights.new(item_id: @ht_id)
    @rights_attribute = @rights.attribute
    @rights_reason = @rights.reason
  end
end
