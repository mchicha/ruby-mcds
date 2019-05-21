require 'rails_helper'

RSpec.describe Program, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:status) }
  it { should belong_to(:delivery_method) }
  it { should have_many(:geographies).through(:geography_program) }
  it { should have_and_belong_to_many(:date_ranges) }
  it { should have_and_belong_to_many(:color_blocks) }
  it { should have_many(:resources)}

  context "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:geography_program) }
  end

  describe "#associated_to_users_geographies(user)" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @co_op_programs = Program.associated_to_users_geographies(@user)
    end

    it "should be empty if the user has no geographies associated to them" do
      expect(@co_op_programs).to be_empty
    end

    it 'should return programs if a program is only assigned to National' do
      program = FactoryGirl.create(:program, :assigned_to_national)
      @co_op_programs = Program.associated_to_users_geographies(program.user)
      expect(@co_op_programs).to_not be_empty
    end

    it "should be empty if the user is associated to a co-op that doesn't have any programs" do
      @user = FactoryGirl.create(:user, :with_geography)
      expect(@co_op_programs).to be_empty
    end
  end

  describe "#pop_install_date" do
    let(:program) { FactoryGirl.create(:program, :with_geographies) }
    it "should return nil if no pop install dates have been set" do
      expect(program.date_range_for_type("pop_install")).to be_falsey
    end
  end

  describe "#convert_string_to_date(date)" do
    it "should convert the string into a date object" do
      string = "12/01/2014"
      expect(Program.convert_string_to_date(string).class).to eq(Date)
    end

    it "should return today's date object if no string is passed in" do
      expect(Program.convert_string_to_date(nil)).to eq(Date.today)
    end

  end

  describe "#for_specific_geographies(geography_ids)" do
    it "should return a list of programs based on the program's association to geographies" do
      program = FactoryGirl.create(:program, :with_geographies)
      geography_ids = program.geographies.collect(&:id)
      expect(Program.for_specific_geographies(geography_ids).length).to eq(1)
    end
  end

  describe "#updated_at_range(date1, date2)" do
    let(:start_date) {"12/01/2014" }
    let(:end_date) {"12/25/2014"}

    it "should return a blank array if there are programs that fall outside of the range" do
      program = FactoryGirl.create(:program, :last_updated, :with_geographies)
      expect(Program.updated_at_range(start_date, end_date)).to be_empty
    end

    it 'should return an array if there are programs within the specified date range' do
      start_date = "11/01/2013"
      program = FactoryGirl.create(:program, :last_updated, :with_geographies)
      expect(Program.updated_at_range(start_date, end_date)).to_not be_empty
    end

    it "should fail if it can't convert one of the dates to a date object" do
      start_date = "test"
      program = FactoryGirl.create(:program, :last_updated, :with_geographies)
      expect(Program.updated_at_range(start_date, end_date)).to be_empty
    end
  end

  describe "#for_specific_users(user_ids)" do
    let(:user) { FactoryGirl.create(:user, :created_programs)}
    it "should return at least 1 program when filtering for a user" do
      expect(Program.for_specific_users(user.id)).to_not be_empty
    end

    it 'should return an empty array if the users selected have no programs' do
      user = FactoryGirl.create(:user)
      expect(Program.for_specific_users(user.id)).to be_empty
    end

  end

  describe "#date_ranges_for_type(start_date, end_date, date_type)" do
    let(:end_date) { Date.today + 25}

    it 'should return nothing based on the dates passed in' do
      start_date = Date.today + 25
      program = FactoryGirl.create(:program, :pop_install_dates, :with_geographies)
      expect(Program.date_ranges_for_type(start_date.strftime("%m/%d/%Y"), end_date.strftime("%m/%d/%Y"), "pop_install")).to be_empty
    end

    it 'should return an array of programs if the dates are in range' do
      start_date = Date.today
      program = FactoryGirl.create(:program, :pop_install_dates, :with_geographies)
      expect(Program.date_ranges_for_type(start_date.strftime("%m/%d/%Y"), end_date.strftime("%m/%d/%Y"), "pop_install")).to_not be_empty
    end

  end

  describe "#filter_by_name_or_geography(keyword)" do
    let(:program) {FactoryGirl.create(:program, :with_geographies)}
    it "should return 0 results if no program matches the name or geography searched for" do
      keyword = "Chicken Livers"
      expect(Program.filter_by_name_or_geography(keyword)).to be_empty
    end

    it "should return a result if the name matches but not the geography" do
      keyword = "Fake"
      program = FactoryGirl.create(:program, :with_specific_name, :with_geographies)
      expect(Program.filter_by_name_or_geography(keyword)).to_not be_empty
    end

    it "should return a result if a geography matches but no name" do
      keyword = "na"
      program = FactoryGirl.create(:program, :assigned_to_national)
      expect(Program.filter_by_name_or_geography(keyword)).to_not be_empty
    end



  end


end
