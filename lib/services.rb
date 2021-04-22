# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env')
require 'canister'
require 'sequel'
require 'rights_database/rights'
require 'rights_database/rights_attributes'
require 'rights_database/rights_reasons'

Services = Canister.new

Services.register(:rights_db) do
  Sequel.connect(adapter: :mysql2,
                 database: 'ht_rights',
                 host: ENV['DB_HOST'],
                 user: ENV['DB_USER'],
                 password: ENV['DB_PASSWORD'])
end

Services.register(:rights) { RightsDatabase::Rights }
Services.register(:rights_attributes) { RightsDatabase::RightsAttributes.new }
Services.register(:rights_reasons) { RightsDatabase::RightsReasons.new }
