require 'rails_helper'

RSpec.describe User, :type => :model do

  it { should have_many(:programs) }
  it { should have_many(:geography_users) }
  it { should have_many(:geographies).through(:geography_users) }
  it { should have_many(:contact_lists) }
  it { should have_many(:contact_list_users).through(:contact_lists) }
  it { should have_many(:message_users).through(:messages) }

  it { should have_and_belong_to_many(:agencies) }

  describe "#full_name" do

    it "should return First Last" do
      user = FactoryGirl.create(:user)
      expect(user.full_name).to eq("First Last")
    end

    it "should return only First if user has no last name" do
      user = FactoryGirl.create(:user, :no_last_name)
      expect(user.full_name).to eq("First")
    end

  end


end
