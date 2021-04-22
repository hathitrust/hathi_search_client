# frozen_string_literal: true

require 'services'

module RightsDatabase
  # Rights for an individual HT item
  class Rights
    attr_accessor :item_id, :attr, :reason, :source, :time, :note, :access_profile, :user, :namespace, :id, :attribute

    def initialize(item_id:, attr: nil, reason: nil, source: nil, time: nil, note: nil, access_profile: nil, user: nil)
      @item_id = item_id
      @namespace, @id = @item_id.split(/\./, 2)
      if @attr.nil?
        load_from_db
      else
        @attr = attr
        @reason = reason
        @source = source
        @time = time
        @note = note
        @access_profile = access_profile
        @user = user
      end
      @attribute = Services.rights_attributes[@attr].name
      @reason = Services.rights_reasons[@reason].name
    end

    def load_from_db
      rights = Services.rights_db[:rights_current]
                       .where(namespace: namespace, Sequel.qualify(:rights_current, :id) => id)
                       .first
      rights.each { |k, v| public_send("#{k}=", v) }
    end
  end
end
