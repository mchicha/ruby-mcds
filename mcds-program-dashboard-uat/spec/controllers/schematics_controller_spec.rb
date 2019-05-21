require 'rails_helper'

RSpec.describe SchematicsController, :type => :controller do

  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user) }
  end

  describe '#index' do
    it "should return a successful response" do
      get :index, format: :html
      expect(response.status).to eq(200)
    end
  end


  describe "#print" do
    it "should return a successful rsponse" do
      get :print, format: :html
      expect(response.status).to eq(200)
    end

    it "should render the print layout" do
      get :print, format: :html
      expect(response).to render_template(layout: :print)
    end
  end


end
