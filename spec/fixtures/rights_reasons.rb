# frozen_string_literal: true

require 'rights_database/rights_reasons'
Reason = RightsDatabase::Reason

def mock_reasons
  RightsDatabase::RightsReasons.new(
    1 => Reason.new(id: 1, name: 'bib', dscr: 'bibliographically-derived by automatic processes'),
    2 => Reason.new(id: 2, name: 'ncn', dscr: 'no printed copyright notice'),
    3 => Reason.new(id: 3, name: 'con', dscr: 'contractual agreement with copyright holder on file'),
    4 => Reason.new(id: 4, name: 'ddd', dscr: 'due diligence documentation on file'),
    5 => Reason.new(id: 5, name: 'man', dscr: 'manual access control override; see note for details'),
    6 => Reason.new(id: 6, name: 'pvt', dscr: 'private personal information visible'),
    7 => Reason.new(id: 7, name: 'ren', dscr: 'copyright renewal research was conducted'),
    8 => Reason.new(id: 8, name: 'nfi', dscr: 'needs further investigation (copyright research partially complete, and an ambiguous, unclear, or other time-consuming situation was encountered)'),
    9 => Reason.new(id: 9, name: 'cdpp', dscr: 'title page or verso contain copyright date and/or place of publication information not in bib record'),
    10 => Reason.new(id: 10, name: 'ipma', dscr: 'in-print and market availability research was conducted'),
    11 => Reason.new(id: 11, name: 'unp', dscr: 'unpublished work'),
    12 => Reason.new(id: 12, name: 'gfv', dscr: 'Google viewability set at VIEW_FULL'),
    13 => Reason.new(id: 13, name: 'crms', dscr: 'derived from multiple reviews in the Copyright Review Management System (CRMS) via an internal resolution policy; consult CRMS records for details'),
    14 => Reason.new(id: 14, name: 'add', dscr: 'author death date research was conducted or notification was received from authoritative source'),
    15 => Reason.new(id: 15, name: 'exp', dscr: 'expiration of copyright term for non-US work with corporate author'),
    16 => Reason.new(id: 16, name: 'del', dscr: 'deleted from the repository; see note for details'),
    17 => Reason.new(id: 17, name: 'gatt', dscr: 'non-US public domain work restored to in-copyright in the US by GATT'),
    18 => Reason.new(id: 18, name: 'supp', dscr: 'suppressed from view; see note for details')
  )
end
