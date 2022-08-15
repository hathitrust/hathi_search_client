# frozen_string_literal: true

require "spec_helper"
require "search"

RSpec.describe Search do
  let(:s) { Search.new(%w[author publisher], ["Australian National University", "ANU"]) }

  describe "#num_results" do
    xit "provides the number of results" do
      expect(s.num_results).to be > 5
    end
  end

  describe "#records" do
    xit "compiles all of the records" do
      rec_count = s.records.count
      expect(rec_count).to eq(s.num_results)
    end
  end

  describe "#records_to_tsv" do
    xit "gives us a tsv line for each ht item" do
      row = s.records_to_tsv.first
      expect(row).to eq(["000600918",
        "Women's work and women's roles : economics and everyday life in Indonesia, Malaysia, and Singapore",
        "Manderson, Lenore.; Australian National University.",
        "Australian National University ;; Distributed by ANU Press,",
        "1983",
        "uva.x001592955",
        "1983",
        "",
        "cc-by-nc-nd-4.0",
        "con"].join("\t"))
    end

    xit "joins multiple subjects with ;" do
      rec = CatalogRecord.new_from_doc(JSON.parse(File.read("spec/data/fullrecord.json")))
      s.records = [rec]
      expect(s.records_to_tsv.first.split("\t")[6]).to eq(rec.subject.join("; "))
    end
  end
end
