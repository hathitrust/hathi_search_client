# frozen_string_literal: true

require "spec_helper"
require "catalog_record"
require "json"

RSpec.describe CatalogRecord do
  let(:doc) do
    {"id" => "000600918",
     "sdrnum" => ["sdr-uva.u1370511", "sdr-ucsc.b10578365"],
     "author" => ["Manderson, Lenore.", "Australian National University."],
     "title" => ["A Shorter Title", "A Longer Title That Is Ignored"],
     "topicStr" => ["Women", "Women Singapore Economic conditions"],
     "publishDate" => ["1983"],
     "publisher" => ["Australian National University ;", "Distributed by ANU Press,"],
     "ht_json" => '[{"htid":"uva.x001592955","newly_open":null,"ingest":"20201208","rights":["cc-by-nc-nd-4.0",null],"heldby":["anu","asu","auburn","auckland","universityofcalifornia","brown","bu","columbia","cornell","dartmouth","duke","harvard","hawaii","iastate","illinois","iu","jhu","ksu","miami","monash","msu","northwestern","nypl","ox","princeton","smith","stanford","ua","uchicago","uiowa","umass","umich","umn","unc","unimelb","unsw","upenn","uq","usg","utexas","utoronto","uwo","virginia","wisc","yorku"],"collection_code":"uva","enum_pubdate":"1983","enum_pubdate_range":"1980-1989","dig_source":"google"},{"htid":"inu.30000000079024","newly_open":null,"ingest":"20200525","rights":["cc-by-nc-nd-4.0",null],"heldby":["anu","asu","auburn","auckland","universityofcalifornia","brown","bu","columbia","cornell","dartmouth","duke","harvard","hawaii","iastate","illinois","iu","jhu","ksu","miami","monash","msu","northwestern","nypl","ox","princeton","smith","stanford","ua","uchicago","uiowa","umass","umich","umn","unc","unimelb","unsw","upenn","uq","usg","utexas","utoronto","uwo","virginia","wisc","yorku"],"collection_code":"ucsc","enum_pubdate":"1983","enum_pubdate_range":"1980-1989","dig_source":"google"}]'}
  end
  let(:rec) { CatalogRecord.new_from_doc(doc) }
  let(:full_doc) { JSON.parse(File.read("spec/data/fullrecord.json")) }
  let(:full_rec) { CatalogRecord.new_from_doc(full_doc) }

  describe "#new_from_doc" do
    it "extracts the fields we want" do
      expect(rec.zephir_cid).to eq("000600918")
      expect(rec.title).to eq("A Shorter Title")
      expect(rec.authors).to eq(["Manderson, Lenore.", "Australian National University."])
      expect(rec.publisher).to eq(["Australian National University ;", "Distributed by ANU Press,"])
      expect(rec.title_pub_date).to eq(["1983"])
      expect(rec.subject).to eq(["Women", "Women Singapore Economic conditions"])
    end

    it "pulls the Rec Source Code from HOL$s" do
      expect(full_rec.rec_src_code).to eq("UVA")
    end

    it "pulls ht items from the ht_json" do
      expect(rec.ht_items.count).to eq(2)
      expect(rec.ht_items.first.ht_id).to eq("uva.x001592955")
    end
  end
end
