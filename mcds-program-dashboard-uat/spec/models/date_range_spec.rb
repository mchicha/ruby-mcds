require 'rails_helper'

RSpec.describe DateRange, :type => :model do

  it {should belong_to(:date_type) }
  it {should have_and_belong_to_many(:programs) }


end
