# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env')
require 'canister'
require 'sequel'
require 'rights_database/rights_db'
require 'rights_database/rights'
require 'rights_database/rights_attributes'
require 'rights_database/rights_reasons'
require 'solr_catalog'

Services = Canister.new

Services.register(:solr_catalog) { SolrCatalog.new.solr }
Services.register(:rights_db) { RightsDatabase::RightsDB.new }
Services.register(:rights) { RightsDatabase::Rights }
Services.register(:rights_attributes) { RightsDatabase::RightsAttributes.new }
Services.register(:rights_reasons) { RightsDatabase::RightsReasons.new }
Services.register(:users) { File.readlines(ENV.fetch('USERS_FILE', nil)).map(&:chomp).to_set }
