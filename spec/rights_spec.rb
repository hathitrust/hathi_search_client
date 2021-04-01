# frozen_string_literal: true

require 'spec_helper'
require 'rights'

RSpec.describe Rights do
  
  describe '#new' do
    it "retrieves a rights record for an item id" do
      item_rights = Rights.new(item_id: 'uva.x001592955')
      expect(item_rights.attr).to eq(5)
    end
  end
end
