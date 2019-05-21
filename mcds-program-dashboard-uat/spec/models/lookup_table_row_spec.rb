require 'rails_helper'

describe LookupTableRow do

  subject(:lookup_table_row) { build(:lookup_table_row) }

  it { is_expected.to be_valid }

  it { is_expected.to belong_to(:lookup_table) }


  it { is_expected.to validate_presence_of(:key) }

end
