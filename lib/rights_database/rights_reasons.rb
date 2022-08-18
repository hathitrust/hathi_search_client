# frozen_string_literal: true

require "services"

module RightsDatabase
  # Reason description
  class Reason
    attr_reader :id, :name, :dscr

    def initialize(id:, name:, dscr:)
      @id = id
      @name = name
      @description = dscr
    end
  end

  class RightsReasons
    attr_accessor :reasons

    def initialize(reasons = load_from_db)
      @reasons = reasons
    end

    def load_from_db
      Services.rights_db[:reasons]
        .select(:id,
          :name,
          :dscr)
        .as_hash(:id)
        .transform_values { |h| Reason.new(**h) }
    end

    def [](reason)
      @reasons[reason] || unknown
    end

    def unknown
      @unknown ||= Reason.new(id: nil, name: "unknown", dscr: "Not in rights database")
    end
  end
end
