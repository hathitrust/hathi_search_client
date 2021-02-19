# frozen_string_literal: true

require 'spec_helper'
require 'ht_item'
require 'json'

RSpec.describe HTItem do
  let(:solr_item) do
    JSON.parse('{"htid":"uva.x001592955","newly_open":null,"ingest":"20201208","rights":["cc-by-nc-nd-4.0",null],"heldby":["anu","asu","auburn","auckland","universityofcalifornia","brown","bu","columbia","cornell","dartmouth","duke","harvard","hawaii","iastate","illinois","iu","jhu","ksu","miami","monash","msu","northwestern","nypl","ox","princeton","smith","stanford","ua","uchicago","uiowa","umass","umich","umn","unc","unimelb","unsw","upenn","uq","usg","utexas","utoronto","uwo","virginia","wisc","yorku"],"collection_code":"uva","enum_pubdate":"1983","enum_pubdate_range":"1980-1989","dig_source":"google"}')
  end

  describe '#new' do
    it 'extracts the fields we want from the solr record' do
      item = HTItem.new(solr_item)
      expect(item.ht_id).to eq('uva.x001592955')
      expect(item.rights).to eq('cc-by-nc-nd-4.0')
      expect(item.enum_chron).to eq('')
      expect(item.pub_date).to eq('1983')
    end

    xit 'pulls rights and rights reason from the rights database' do
      item = HTItem.new(solr_item)
      expect(item.db_reason).to eq("This isn't implemented yet.")
      expect(item.db_rights).to eq('cc-by-nc-nd-4.0')
    end
  end
end
