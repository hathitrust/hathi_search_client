# frozen_string_literal: true

require 'spec_helper'
require 'query'

RSpec.describe Query do
  let(:q) { Query.new(%w[author publisher], ['Australian National University', 'ANU']) }
  it 'takes a list of indexes and a list of terms' do
    expect(q.indexes).to eq(%w[author publisher])
    expect(q.terms).to eq(['Australian National University', 'ANU'])
  end

  it 'compiles the indexes and terms into a query string' do
    expect(q.to_str).to eq('author:"Australian National University" OR author:"ANU" OR publisher:"Australian National University" OR publisher:"ANU"')
  end
end
