require 'rails_helper'

RSpec.describe DateType, :type => :model do

  it {should have_many(:date_ranges) }

  describe "#get_class_name" do

    it "should return a class name of lighter if nil" do
      date_type = FactoryGirl.create(:date_type)
      expect(date_type.get_class_name).to eq("lighter")
    end

    it "should return a class name of test when a date type has a class name assigned" do
      date_type = FactoryGirl.create(:date_type, :with_class_name)
      expect(date_type.get_class_name).to eq("test")
    end

  end

end
