# frozen_string_literal: true

# fozen_string_literal: true
require 'rights_database/rights'

class MockRights < RightsDatabase::Rights
  def load_from_db
    # namespace => {attr: id, reason: attr, source: reason, access_profile: source, user: "access_profile", time:"user | time | note |
    fake_rights = {
      'inu.30000000078026' => { attr: 2, reason: 1, source: 1, access_profile: 2, user: 'jhovater', time: '2009-10-15 23:30:23' },
      'inu.30000000078232' => { attr: 2, reason: 1, source: 1, access_profile: 2, user: 'jhovater', time: '2009-10-19 21:30:29' },
      'inu.30000000079024' => { attr: 1, reason: 1, source: 1, access_profile: 2, user: 'aelkiss ', time: '2010-06-10 19:30:05' },
      'uva.x001592955' => { attr: 22, reason: 3, source: 1, access_profile: 2, user: 'keden', time: '2020-03-19 16:57:04' }

    }

    fake = (fake_rights[@item_id] || { attr: 1, reason: 1, source: 1, access_profile: 2, user: 'aelkiss ', time: '2010-06-10 19:30:05' })

    @attr = fake[:attr]
    @reason = fake[:reason]
  end
end

def mock_rights
  MockRights
end
