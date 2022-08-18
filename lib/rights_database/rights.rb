# frozen_string_literal: true

require "services"

module RightsDatabase
  # Rights for an individual HT item
  class Rights
    attr_accessor :item_id, :attribute, :reason, :source, :time, :note, :access_profile, :user, :namespace, :id

    def initialize(item_id:)
      @item_id = item_id
      @namespace, @id = @item_id.split(/\./, 2)
      load_from_db
    end

    def load_from_db
      rights = Services.rights_db[:rights_current]
        .where(:namespace => namespace, Sequel.qualify(:rights_current, :id) => id)
        .first || unknown_rights
      rights.each do |k, v|
        case k
        when :reason
          @reason = Services.rights_reasons[v]
        when :attr
          @attribute = Services.rights_attributes[v]
        else
          public_send("#{k}=", v)
        end
      end
    end

    # null object for items missing rights
    def unknown_rights
      {
        namespace: namespace,
        id: id,
        attr: nil,
        reason: nil,
        source: nil,
        time: nil,
        note: "Item not in rights database",
        access_profile: nil,
        user: nil
      }
    end
  end
end
