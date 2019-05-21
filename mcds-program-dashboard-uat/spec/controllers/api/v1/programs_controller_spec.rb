require 'rails_helper'

RSpec.describe Api::V1::ProgramsController, :type => :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { @user }
  end

  describe "#index" do
    before(:each) do
      @nat_geography = FactoryGirl.create(:geography, :national)
      @coop_geography = FactoryGirl.create(:geography, name: 'Mon Calamari')
      @progam_in_range = FactoryGirl.create(:program, :pop_install_dates, geographies: [@nat_geography])
      @progam_in_range2 = FactoryGirl.create(:program, :pop_install_dates, geographies: [@nat_geography])
      @progam_out = FactoryGirl.create(:program, :far_away_pop_install_dates, geographies: [@nat_geography])
      @coop_progam = FactoryGirl.create(:program, :pop_install_dates, geographies: [@coop_geography])
    end

    context 'with national geography selected' do
      before(:each) do
        @user.selected_geography = @nat_geography
        @user.save
      end

      it "must only return no programs with a bad range" do
        ancient_date = Date.today - 100000
        get :index, popStartDate: ancient_date.to_s, popEndDate: (ancient_date + 7).to_s,  format: :json
        result = JSON.parse(response.body)
        expect(result['programs'].length).to eq(0)
      end

      it "must only return national programs inside the date range" do
        today = Date.today
        get :index, popStartDate: today.to_s, popEndDate: (today + 7).to_s,  format: :json
        result = JSON.parse(response.body)
        expect(result['programs'].length).to eq(2)
      end

      it "must return a programs even if only the pop start is inside the range" do
        today = Date.today
        get :index, popStartDate: (today - 2).to_s, popEndDate: (today + 2).to_s,  format: :json
        result = JSON.parse(response.body)
        expect(result['programs'].length).to eq(2)
      end
    end

    context 'with a coop geography selected' do
      before(:each) do
        @user.selected_geography = @coop_geography
        @user.save
      end

      it 'must return national and coop programs' do
        today = Date.today
        get :index, popStartDate: today.to_s, popEndDate: (today + 7).to_s,  format: :json
        result = JSON.parse(response.body)
        expect(result['programs'].length).to eq(3)
      end
    end
  end

end
