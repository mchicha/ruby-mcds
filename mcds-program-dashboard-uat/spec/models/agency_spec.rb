require 'rails_helper'

RSpec.describe Agency, :type => :model do

  it { should have_and_belong_to_many(:users) }
  it { should have_and_belong_to_many(:geographies) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

end
