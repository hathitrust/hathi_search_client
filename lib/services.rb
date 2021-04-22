# frozen_string_literal: true

require "canister"

Services = Canister.new

Services.register(:rights_db) { RightsDB.new }
