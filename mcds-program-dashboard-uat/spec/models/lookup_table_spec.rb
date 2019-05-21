require 'rails_helper'

describe LookupTable do

  subject(:lookup_table) { build(:lookup_table) }

  it { is_expected.to be_valid }

  it { is_expected.to have_many(:lookup_table_rows) }

  it { is_expected.to validate_presence_of(:key_field_name) }

end
