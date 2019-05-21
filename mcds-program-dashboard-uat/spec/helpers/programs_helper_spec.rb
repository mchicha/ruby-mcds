require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ProgramsHelper. For example:
#
# describe ProgramsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ProgramsHelper, :type => :helper do

  describe "#unique_users_who_created_programs" do

    it "should return an empty array if no programs exist" do
      @user = FactoryGirl.create(:user)
      @programs = Program.associated_to_users_geographies(@user)
      expect(helper.unique_users_who_created_programs).to be_empty
    end

  end

  describe "#program_date_range" do
    before(:each) do
      @pop_install = FactoryGirl.create(:date_type, :pop_install_type)
    end

    it "should return 'Not yet set' if a program doesn't have pop install dates assigned" do
      program = FactoryGirl.create(:program, :with_geographies)
      expect(helper.program_date_range(program, @pop_install)).to eq("Not yet set")
    end

    it 'should return a date in the mm/dd/yyyy format if there is a pop_install date set' do
      program = FactoryGirl.create(:program, :with_geographies, :pop_install_dates)
      expect(helper.program_date_range(program, program.date_ranges.first.date_type)).to eq("#{Date.today.strftime('%m/%d/%Y')} - #{(Date.today + 5).strftime('%m/%d/%Y')}")
    end

  end

  describe "#find_agencies_from_assign_geographies" do

    it "should return a count of 0 if the program is associated to a geography that isn't assigned to an agency" do
      program = FactoryGirl.create(:program, :with_geographies)
      expect(helper.find_agencies_from_assign_geographies(program).count).to eq(0)
    end

    it "should return array of agencies for the given program" do
      program = FactoryGirl.create(:program, :with_geographies_associated_to_agency)
      expect(helper.find_agencies_from_assign_geographies(program)).not_to be_empty
    end

  end

end
