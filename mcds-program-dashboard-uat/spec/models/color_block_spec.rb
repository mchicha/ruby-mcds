require 'rails_helper'

RSpec.describe ColorBlock, :type => :model do
  it { should have_and_belong_to_many(:programs) }
  it { should have_and_belong_to_many(:users) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_hex) }
  it { should allow_value("#654321").for(:start_hex) }
  it { should allow_value("#654321").for(:end_hex) }
end
