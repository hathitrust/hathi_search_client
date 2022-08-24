require "spec_helper"
require "rack/test"
require_relative "../search_client"

RSpec.describe "Sinatra::Application" do
  include Rack::Test::Methods
  let(:app) { Sinatra::Application }
  OmniAuth.config.test_mode = true

  def search
    get "/", indexes: ["author"], terms: ["chaucer"], search: "Search"
  end

  def get_tsv
    get "/", indexes: ["author"], terms: ["chaucer"], results: "Get TSV"
  end

  it "can get search form" do
    get "/"
    expect(last_response.content_type).to start_with("text/html")
    expect(last_response.body).to include("<form>")
  end

  it "can get result count" do
    search
    expect(last_response.body.match(/Number of result records: (\d+)/)[1].to_i).to be > 5
  end

  describe "search results" do
    before(:each) { get_tsv }

    it "returns plain text" do
      expect(last_response.content_type).to start_with("text/plain")
    end

    it "has a header row" do
      expect(last_response.body).to match(/^Zephir_CID.*reason$/m)
    end

    it "includes the search" do
      expect(last_response.body).to match(/Terms: chaucer/)
    end

    it "doesn't have blank lines" do
      expect(last_response.body.lines).not_to include("")
    end

    it "includes result records" do
      expect(last_response.body.lines.count { |i| i.match(/^\d+/) }).to be > 0
    end
  end
end
