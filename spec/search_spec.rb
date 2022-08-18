# frozen_string_literal: true

require "spec_helper"
require "search"

RSpec.describe Search do
  let(:s) { Search.new(%w[author], ["Chaucer"]) }

  describe "#num_results" do
    it "provides the number of results" do
      expect(s.num_results).to be > 5
    end
  end

  describe "#records_to_tsv" do
    it "gives us a tsv line for each ht item" do
      row = s.records_to_tsv.first
      expect(row.split("\t").size).to eq(12)
    end

    it "includes matching results" do
      s.records_to_tsv.each do |row|
        expect(row).to match(/Chaucer/)
      end
    end
  end

  describe "#record_to_tsv" do
    it "joins multiple subjects with ;" do
      rec = CatalogRecord.new_from_doc(JSON.parse(File.read("spec/data/fullrecord.json")))
      expect(s.record_to_tsv(rec).first.split("\t")[6]).to eq(rec.subject.join("; "))
    end
  end
end
