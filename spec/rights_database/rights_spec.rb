# frozen_string_literal: true

require 'spec_helper'
require 'rights_database/rights'

RSpec.describe RightsDatabase::Rights do
  describe '#new' do
    xit 'retrieves a rights record for an item id' do
      item_rights = RightsDatabase::Rights.new(item_id: 'uva.x001592955')
      expect(item_rights.attr).to eq(22)
    end
  end
end
