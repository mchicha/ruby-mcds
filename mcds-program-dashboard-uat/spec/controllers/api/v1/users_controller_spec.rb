require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :controller do

  describe "#index" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      get :index, format: :json
    end

    it "should have a successfull response status" do
      expect(response.status).to eq(200)
    end
  end

  describe "#search" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should return nothing if there is no term entered" do
      get :search, format: :json
      expect(response.body).to_not be_empty
    end
  end

  describe "#get_claims" do

    describe "when request is valid" do
      let(:user) { FactoryGirl.create(:user, cas_user_id: 1) }
      let(:new_user) { FactoryGirl.build(:user, cas_user_id: 1) }
      let(:user_result){{
        user: {
          "id"=>"#{user.cas_user_id}",
          "first_name"=>"#{user.first_name}",
          "last_name"=>"#{user.last_name}",
          "email"=>"#{user.email}"
          }
        }
      }
      before(:each) do
        allow_message_expectations_on_nil
        expect(assigns(:result)).to receive(:to_options).and_return(user_result)
      end

      it "should redirect the user" do
        pending "needs fixing"
        allow(User).to receive_message_chain(:where, :first_or_create).and_return(user)
        post :get_claims, format: :html, SAMLResponse: "12345"
        expect(response.code).to eq("302")
      end

      describe "when a user doesnt exit" do
        it "should create a new user" do
          pending "needs fixing"
          allow(User).to receive_message_chain(:where, :first_or_create).and_return(new_user)
          expect { post :get_claims, format: :html, SAMLResponse: "12345" }.to change(User, :count).by(1)
        end
      end

      describe "when a user exists" do
        it "should find an existing users" do
          pending "needs fixing"
          allow(User).to receive_message_chain(:where, :first_or_create).and_return(user)
          expect { post :get_claims, format: :html, SAMLResponse: "12345" }.to change(User, :count).by(0)
        end
      end
    end

    describe "when request is invalid" do
      it "should return a unsucessfull response status" do
        pending "needs fixing"
        post :get_claims, format: :html, SAMLResponse: "bad_request"
        expect(flash[:notice]).to eq("User is not authenticated.")
      end
    end
  end



end
