# frozen_string_literal: true

# Converts query indexes and terms
class Query
  attr_accessor :indexes, :terms

  def initialize(indexes, terms)
    @indexes = indexes
    @terms = terms
  end

  def to_a
    q_list = []
    q_list = []
    indexes.each do |index|
      terms.each do |term|
        q_list << [index, "\"#{term.delete('"')}\""].join(":")
      end
    end
    q_list
  end

  def to_str
    to_a.join(" OR ")
  end
end
