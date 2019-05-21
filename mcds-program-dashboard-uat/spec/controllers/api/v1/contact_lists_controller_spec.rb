require 'rails_helper'

RSpec.describe Api::V1::ContactListsController, :type => :controller do

  describe "#search_contact_lists" do
    before(:each) do
      @contact_list1 = FactoryGirl.create(:contact_list, :with_name_abcx)
      @contact_list2 = FactoryGirl.create(:contact_list, :with_name_xyz)
    end

    it "should return nothing if there is no term entered" do
      get :search_contact_lists, format: :json, user_id: 111, term: nil
      expect(response.body).to be_blank
    end

    it "should return one contact list if term = 'a'" do
      get :search_contact_lists, format: :json, user_id: 111, term: 'a'
      expect(response.body.scan("label").count).to equal 1
    end

    it "should return two contact list if term = 'x'" do
      get :search_contact_lists, format: :json, user_id: 111, term: 'x'
      expect(response.body.scan("label").count).to equal 2
    end

  end

end
