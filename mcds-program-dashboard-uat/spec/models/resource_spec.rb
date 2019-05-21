require 'rails_helper'

RSpec.describe Resource, :type => :model do
  it { should validate_presence_of(:file) }
  it { should belong_to(:resourceable) }

  context "bad file" do

    it "should error when saving XML file" do
      bad_resource = FactoryGirl.build(:bad_resource)
      bad_resource.should_not be_valid

      # will have two errors: no file presence, and incorrect type
      expect(bad_resource.errors.messages[:file].count).to eq(2)
    end

    it "should error if file is too large" do
      resource = FactoryGirl.build(:resource)
      resource.file.stub(:size).and_return(51.megabytes)
      resource.should_not be_valid
      expect(resource.errors.messages[:file].count).to eq(1)
    end

  end
end
