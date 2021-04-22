# frozen_string_literal: true

class HTItem
  attr_accessor :ht_id, :rights, :enum_chron, :pub_date, :db_rights, :db_reason, :id, :namespace

  def initialize(solr_item)
    @ht_id = solr_item['htid']
    @enum_chron = solr_item['enumcron'] || ''
    @pub_date = solr_item['enum_pubdate'] || ''
    @rights = solr_item['rights'][0]
    @db_rights, @db_reason = fetch_rights_and_reason
    @namespace, @id = @ht_id.split(/\./, 2)
  end

  def fetch_rights_and_reason
    [nil, nil]
  end
end
