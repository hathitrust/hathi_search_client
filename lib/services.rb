# frozen_string_literal: true
<<<<<<< HEAD
require "dotenv"
Dotenv.load(".env")
require "canister"
require "sequel"

Services = Canister.new

Services.register(:rights_db) do
  Sequel.connect( adapter: :mysql2,
                  database: 'ht_rights',
                  host: ENV['DB_HOST'],
                  user: ENV['DB_USER'])
end
