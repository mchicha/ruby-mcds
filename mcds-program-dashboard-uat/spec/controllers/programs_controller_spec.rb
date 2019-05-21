require 'spec_helper'

RSpec.describe ProgramsController, :type => :controller do

  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user, role: 0) }
  end

  describe "#new" do
    before(:each) { @geography = FactoryGirl.create(:geography) }
    before(:each) { @delivery_method = FactoryGirl.create(:delivery_method) }
    before(:each) { FactoryGirl.create(:status, :planning) }

    it "should return a succesful page" do
      get :new
      expect(response.status).to eq(200)
    end

  end

  describe "#create" do
    before(:each){@geography = FactoryGirl.create(:geography)}
    before(:each) { @delivery_method = FactoryGirl.create(:delivery_method) }


    it "should return successful save" do
      post :create, :program => {"name" => "Test Program", delivery_method_id: @delivery_method.id}, :geography_ids =>[@geography.id]

      expect(response).to redirect_to(programs_path)
    end

    it "should return an error if name isn't present" do
      post :create, :program => {"name" => nil, delivery_method_id: @delivery_method.id}, :geography_ids =>[@geography.id]
      expect(flash['error']).to eq("Name can't be blank")
    end

    it "should return an error if geography isn't present" do
      post :create, :program => {"name" => "Test Program", delivery_method_id: @delivery_method.id}
      expect(flash['error']).to eq("Geography program can't be blank")
    end

    it "should return an error if delivery_method_id isn't present" do
      post :create, :program => {"name" => "Test Program"}, :geography_ids =>[@geography.id]
      expect(flash['error']).to eq("Delivery method can't be blank")
    end


    it "should not create a resource if the resource attributes file is blank" do
      post :create, program: {name: "Test", delivery_method_id: @delivery_method.id, resources_attributes: {"0" => {file: nil}}}, :geography_ids =>[@geography.id]
      @program = Program.last
      expect(@program.resources.count).to eq(0)
    end

    it "should create a resource if the resource attributes file is not blank" do
      new_file = Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/new_image.jpg')))

      post :create, program: {name: "Test", delivery_method_id: @delivery_method.id, resources_attributes: {"0" => {file: new_file}}}, :geography_ids =>[@geography.id]
      @program = Program.last
      expect(@program.resources.count).to eq(1)
    end

    it "should create date ranges for the program" do
      post :create,
      :program =>
        { "name" => "Test Program", delivery_method_id: @delivery_method.id,
          :date_ranges_attributes =>
            { "0"=>{"date_type_id"=>"2", "start_date"=>"09/26/2015", "end_date"=>"10/01/2015"},
              "1"=>{"date_type_id"=>"1", "start_date"=>"09/17/2015"},
              "2"=>{"date_type_id"=>"3", "start_date"=>"09/19/2015"},
              "3"=>{"date_type_id"=>"4", "start_date"=>"10/09/2015"},
              "4"=>{"date_type_id"=>"5", "start_date"=>"09/23/2015"}
            }
        },
      :geography_ids =>[@geography.id]
      @program = Program.last
      expect(@program.date_ranges.count).to eq(5)
    end

    it "should not create date ranges for if program save fails" do
      initial_count = DateRange.count
      post :create,
      :program =>
        { "name" => nil, delivery_method_id: @delivery_method.id,
          :date_ranges_attributes =>
            { "0"=>{"date_type_id"=>"2", "start_date"=>"09/26/2015", "end_date"=>"10/01/2015"},
              "1"=>{"date_type_id"=>"1", "start_date"=>"09/17/2015"},
              "2"=>{"date_type_id"=>"3", "start_date"=>"09/19/2015"},
              "3"=>{"date_type_id"=>"4", "start_date"=>"10/09/2015"},
              "4"=>{"date_type_id"=>"5", "start_date"=>"09/23/2015"}
            }
        },
      :geography_ids =>[@geography.id]
      expect(DateRange.count).to eq(initial_count)
    end
  end

  describe "#update" do
    before(:each) do
      @program = FactoryGirl.create(:program, :with_geographies)
      new_attrs = {
        name: "Updated Prog Name",
        status_id: FactoryGirl.create(:status).id,
        delivery_method_id: FactoryGirl.create(:delivery_method).id,
        notes: "<ol><li>Test</li></ol>"
      }
      put :update, id: @program.id, program: new_attrs, date_type: [], geography_ids: [@program.geographies.first.id]
      @program.reload
    end

    it 'should return a successful update' do
      expect(@program.name).to eq("Updated Prog Name")
    end

    it "should set the current status if updated" do
      expect(@program.status.name).to eq("MyString")
    end

    it "should set the current delivery method to be UPS if selected" do
      expect(@program.delivery_method.name).to eq("UPS")
    end

    it "should save whatever the WYSIWYG editor to the notes section" do
      expect(@program.notes).to_not be_empty
    end

    it 'should redirect the user to the show page for the program' do
      expect(response).to redirect_to(program_path(@program))
    end
  end

  describe "#destroy" do
    let(:program){ FactoryGirl.create(:program, :with_geographies) }
    it 'should delete the program from the db' do
      delete :destroy, id: program.id
      expect(response.status).to eq(302)
    end
  end

  describe "#show" do
    let(:program){ FactoryGirl.create(:program, :with_geographies) }
    it "should find the program and display it in the show view" do
      get :show, id: program.id
      expect(response.status).to eq(200)
    end
  end

  describe "#edit" do
    let(:program){ FactoryGirl.create(:program, :with_geographies) }
    it "should find the program and navigate to the edit page" do
      get :edit, id: program.id
      expect(response.status).to eq(200)
    end
  end

  describe "#assign_geographies" do
    before(:each) do
      @geography = FactoryGirl.create(:geography)
      @program = FactoryGirl.create(:program, :with_geographies)
      post :add_geographies, id: @program.id, geography_ids: [@geography.id]
    end

    it "should increment the count of the program's geographies by 1" do
      expect(@program.geographies.count).to eq(1)
    end

    it "should redirect to the edit program route" do
      expect(response).to redirect_to(edit_program_path(@program))
    end

    it "shouldn't increment the geography count if the geography exists for the given program" do
      program = FactoryGirl.create(:program, :with_geographies)
      post :add_geographies, id: program.id, geography_ids: [program.geographies.first.id]
      expect(program.geographies.count).to eq(1)
    end

    it "should show the user a flash success message when they assign geographies" do
      expect(response.request.flash[:success]).to be_present
    end

  end

  describe "#add_color_blocks" do
    before(:each) do
      @program = FactoryGirl.create(:program, :with_geographies)
      @color_block = FactoryGirl.create(:color_block)
    end

    it "should assign a color block to a program" do
      post :add_color_blocks, id: @program.id, color_block_id: @color_block.id, format: :js
      expect(@program.color_blocks.count).to eq(1)
    end

  end

  describe "#remove_color_block" do
    before(:each) do
      @program = FactoryGirl.create(:program, :with_color_blocks, :with_geographies)
    end

    it "should remove the color block associated to the program" do
      delete :remove_color_block, id: @program.id, color_block_id: @program.color_blocks.first.id, format: :js
      @program.reload
      expect(@program.color_blocks).to be_empty
    end

  end

end
