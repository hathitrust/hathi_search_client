# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'yaml'
require 'search'
require 'pry'

yaml = YAML.safe_load(File.open(ARGV.shift))

search = Search.new(yaml['indexes'], yaml['terms'])

# puts search.query.to_str
# puts search.search_uri
# binding.pry
puts search.header
search.records_to_tsv.each { |r| puts r }
