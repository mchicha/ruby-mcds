require 'rails_helper'

RSpec.describe GeographiesController, :type => :controller do

  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user) }
  end

  describe "#add_user" do
    before(:each) do
      @geography = FactoryGirl.create(:geography)
      @user = FactoryGirl.create(:user)
    end

    it "should add the user to the selected geography" do
      post :add_user, geography_id: @geography.id, user_id: @user.id, checked: "true"
      expect(@user.reload.geographies.include?(@geography)).to eq(true)
    end

    it "should remove the user if the checked param is false" do
      post :add_user, geography_id: @geography.id, user_id: @user.id, checked: "false"
      expect(@user.reload.geographies.include?(@geography)).to eq(false)
    end


  end

end
