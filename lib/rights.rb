# frozen_string_literal: true

require "services"

# Rights for an individual HT item
class Rights
  attr_reader :item_id, :attr, :reason, :source, :time, :note, :access_profile, :user

  def initialize(item_id:, attr: nil, reason: nil, source: nil, time: nil, note: nil, access_profile: nil, user: nil)
    @item_id = item_id
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
  end

  def load_from_db
    namespace, id = item_id.split(/\./, 2)
    rights = Services.rights_db[:rights_current].where(namespace: namespace, id: id).first
    binding.pry
  end  
end
