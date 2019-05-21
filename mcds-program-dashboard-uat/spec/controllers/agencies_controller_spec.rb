require 'rails_helper'

RSpec.describe AgenciesController, :type => :controller do

  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user, role: 4) }
  end

  describe "#create" do

    it "should return a successful save" do
      # allow(controller).to receive(:require_user)
      post :create, :agency => {"name" => "Test Agency"}, format: :js
      expect(response.status).to eq(200)
    end

    it "should not be a valid agency if it has the same name" do
      agency = FactoryGirl.create(:agency)
      expect(FactoryGirl.build(:agency, name: "MyString")).to_not be_valid
    end

    it "should not be a valid agency if it has no name" do
      agency = FactoryGirl.create(:agency)
      expect(FactoryGirl.build(:agency, name: "")).to_not be_valid
    end
  end

  describe "#destroy" do
    it "should return a 200" do
      agency = FactoryGirl.create(:agency)
      delete :destroy, id: agency.id, format: :js
      expect(response.status).to eq(200)
    end
  end

  describe "#destroy_agency_geography" do
    it "should return a 200" do
      agency = FactoryGirl.create(:agency, :with_geographies)
      delete :destroy_agency_geography, id: agency.id, geography_id: agency.geographies.first.id, format: :js
      expect(response.status).to eq(200)
    end

    it "should return a routing error if no geography is provided" do
      agency = FactoryGirl.create(:agency)
      expect{ delete :destroy_agency_geography, id: agency.id, geography_id: nil, format: :js }.to raise_error(ActionController::UrlGenerationError)
    end

  end

  describe "#destroy_agency_user" do
    it "should return a 200" do
      agency = FactoryGirl.create(:agency, :with_users)
      delete :destroy_agency_user, id: agency.id, user_id: agency.users.first.id, format: :js
      expect(response.status).to eq(200)
    end

    it "should return a routing error if no geography is provided" do
      agency = FactoryGirl.create(:agency)
      expect{ delete :destroy_agency_user, id: agency.id, format: :js }.to raise_error(ActionController::UrlGenerationError)
    end

  end

  describe "#add_user_to_agency" do
    before(:each) do
      @agency = FactoryGirl.create(:agency)
      @user = FactoryGirl.create(:user)
    end
    subject { post :add_user_to_agency, id: @agency.id, agency_user: {user_email: @user.email, user_id: @user.id} }

    it "should return a 302" do
      post :add_user_to_agency, id: @agency.id, agency_user: {user_email: @user.email, user_id: @user.id}
      expect(response.status).to eq(302)
    end

    it "should redirect to the manage agency's users page" do
      expect(subject).to redirect_to(agencies_path)
    end

  end

  describe "#add_geographies_to_agency" do
    before(:each) do
      @agency = FactoryGirl.create(:agency)
      @geography = FactoryGirl.create(:geography)
    end

    it "should return a flash error if there are no geographies selected" do
      post :add_geographies_to_agency, id: @agency.id, geography_ids: []
      expect(response.request.flash[:error]).to be_present
    end

    it "should return a 302" do
      post :add_geographies_to_agency, id: @agency.id, geography_ids: [@geography.id]
      expect(response.status).to eq(302)
    end

    it "should add the geography to the agency if a geography is selected" do
      post :add_geographies_to_agency, id: @agency.id, geography_ids: [@geography.id]
      expect(@agency.geographies.count).to eq(1)
    end

  end

  describe "#destroy_all_geographies_from_agency" do
    it "should remove all co-ops from an agency" do
      agency = FactoryGirl.create(:agency, :with_geographies)
      delete :destroy_all_geographies_from_agency, id: agency.id
      expect(agency.geographies.count).to eq(0)
    end
  end

end
