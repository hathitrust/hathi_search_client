# frozen_string_literal: true

require 'rights_database/rights_attributes'
Attribute = RightsDatabase::Attribute

def mock_attributes
  RightsDatabase::RightsAttributes.new(
    1 => Attribute.new(id: 1, type: 'copyright', name: 'pd', dscr: 'public domain'),
    2 => Attribute.new(id: 2, type: 'copyright', name: 'ic', dscr: 'in copyright'),
    3 => Attribute.new(id: 3, type: 'copyright', name: 'op', dscr: 'out-of-print (implies in-copyright)'),
    4 => Attribute.new(id: 4, type: 'copyright', name: 'orph', dscr: 'copyright-orphaned (implies in-copyright)'),
    6 => Attribute.new(id: 6, type: 'access', name: 'umall', dscr: 'available to UM affiliates and walk-in patrons (all campuses)'),
    7 => Attribute.new(id: 7, type: 'access', name: 'ic-world', dscr: 'in-copyright and permitted as world viewable by the copyright holder'),
    5 => Attribute.new(id: 5, type: 'copyright', name: 'und', dscr: 'undetermined copyright status'),
    8 => Attribute.new(id: 8, type: 'access', name: 'nobody', dscr: 'available to nobody; blocked for all users'),
    9 => Attribute.new(id: 9, type: 'copyright', name: 'pdus', dscr: 'public domain only when viewed in the US'),
    10 => Attribute.new(id: 10, type: 'copyright', name: 'cc-by-3.0', dscr: 'Creative Commons Attribution license, 3.0 Unported'),
    11 => Attribute.new(id: 11, type: 'copyright', name: 'cc-by-nd-3.0', dscr: 'Creative Commons Attribution-NoDerivatives license, 3.0 Unported'),
    12 => Attribute.new(id: 12, type: 'copyright', name: 'cc-by-nc-nd-3.0', dscr: 'Creative Commons Attribution-NonCommercial-NoDerivatives license, 3.0 Unported'),
    13 => Attribute.new(id: 13, type: 'copyright', name: 'cc-by-nc-3.0', dscr: 'Creative Commons Attribution-NonCommercial license, 3.0 Unported'),
    14 => Attribute.new(id: 14, type: 'copyright', name: 'cc-by-nc-sa-3.0', dscr: 'Creative Commons Attribution-NonCommercial-ShareAlike license, 3.0 Unported'),
    15 => Attribute.new(id: 15, type: 'copyright', name: 'cc-by-sa-3.0', dscr: 'Creative Commons Attribution-ShareAlike license, 3.0 Unported'),
    16 => Attribute.new(id: 16, type: 'copyright', name: 'orphcand', dscr: 'orphan candidate - in 90-day holding period (implies in-copyright)'),
    17 => Attribute.new(id: 17, type: 'copyright', name: 'cc-zero', dscr: 'Creative Commons Zero license (implies pd)'),
    18 => Attribute.new(id: 18, type: 'access', name: 'und-world', dscr: 'undetermined copyright status and permitted as world viewable by the depositor'),
    19 => Attribute.new(id: 19, type: 'copyright', name: 'icus', dscr: 'in copyright in the US'),
    20 => Attribute.new(id: 20, type: 'copyright', name: 'cc-by-4.0', dscr: 'Creative Commons Attribution 4.0 International license'),
    21 => Attribute.new(id: 21, type: 'copyright', name: 'cc-by-nd-4.0', dscr: 'Creative Commons Attribution-NoDerivatives 4.0 International license'),
    22 => Attribute.new(id: 22, type: 'copyright', name: 'cc-by-nc-nd-4.0', dscr: 'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International license'),
    23 => Attribute.new(id: 23, type: 'copyright', name: 'cc-by-nc-4.0', dscr: 'Creative Commons Attribution-NonCommercial 4.0 International license'),
    24 => Attribute.new(id: 24, type: 'copyright', name: 'cc-by-nc-sa-4.0', dscr: 'Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license'),
    25 => Attribute.new(id: 25, type: 'copyright', name: 'cc-by-sa-4.0', dscr: 'Creative Commons Attribution-ShareAlike 4.0 International license'),
    26 => Attribute.new(id: 26, type: 'access', name: 'pd-pvt', dscr: 'public domain but access limited due to privacy concerns'),
    27 => Attribute.new(id: 27, type: 'access', name: 'supp', dscr: 'suppressed from view; see note for details')
  )
end
