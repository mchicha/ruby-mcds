require 'rails_helper'

RSpec.describe ColorBlocksController, :type => :controller do

  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user, role: 4) }
  end

  describe "#create" do
    it "should return a successful save" do
      post :create, :color_block => {"name" => "Test color_block", "start_hex" => "#654321", "end_hex" => "#654321"}, format: :html
      expect(response.status).to eq(302)
    end

    it "should not be a valid color_block if it has no name" do
      color_block = FactoryGirl.create(:color_block, start_hex: "#123456", end_hex: "#123456")
      expect(FactoryGirl.build(:color_block, name: "")).to_not be_valid
    end

    it "should not be a valid color_block if it has no start_hex" do
      color_block = FactoryGirl.create(:color_block, name: "Test Color Block", start_hex: "#123456", end_hex: "#123456")
      expect(FactoryGirl.build(:color_block, start_hex: "")).to_not be_valid
    end

    it "should not be a valid color_block if start_hex has wrong format" do
      color_block = FactoryGirl.create(:color_block, name: "Test Color Block", start_hex: "#123456", end_hex: "#123456")
      expect(FactoryGirl.build(:color_block, start_hex: "#1234567")).to be_valid
    end
  end

  describe "#update" do
    before(:each) do
      @color_block = FactoryGirl.create(:color_block, name: "Test Color Block", start_hex: "#123456", end_hex: "#123456")
      new_attrs = {name: "Updated Color Block Name"}
      put :update, id: @color_block.id, color_block: new_attrs
      @color_block.reload
    end

    it 'should return a successful update' do
      expect(@color_block.name).to eq("Updated Color Block Name")
    end

    it 'should redirect the user to the index page for the color_block' do
      expect(response).to redirect_to(color_blocks_path)
    end
  end

  describe "#destroy" do
    it "should return a 302 redirect" do
      color_block = FactoryGirl.create(:color_block, name: "Test Color Block", start_hex: "#123456", end_hex: "#123456")
      delete :destroy, id: color_block.id, format: :html
      expect(response.status).to eq(302)
    end
  end
end
