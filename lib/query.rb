# frozen_string_literal: true

# Converts query indexes and terms
class Query
  attr_accessor :indexes, :terms

  def initialize(indexes, terms)
    @indexes = indexes
    @terms = terms
  end

  def to_str
    q_list = []
    indexes.each do |index|
      terms.each do |term|
        q_list << [index, "\"#{term.gsub('"', '')}\""].join(':')
      end
    end
    q_list.join(' OR ')
  end
end
