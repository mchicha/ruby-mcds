require 'rails_helper'

RSpec.describe MessagesController, :type => :controller do

  before(:each) do
    allow(controller).to receive(:require_user)
    allow(controller).to receive(:current_user) { FactoryGirl.create(:user, role: 4) }
  end

  describe "#index" do

    it "should return valid results if there is just an un-archived message" do
      message = FactoryGirl.create(:message, :published_message)
      @messages = Message.unsent
      expect(@messages).to_not be_blank
    end

    it "should return 0 results if there is just an archived message" do
      message = FactoryGirl.create(:message, :archived_message)
      @messages = Message.unsent
      expect(@messages).to be_blank
    end

  end

  describe "#create" do

    # let(:current_user) { FactoryGirl.create(:user) }
    let(:user) { FactoryGirl.create(:user) }

    it "should create a message" do
      post :create, message: {subject: "Test", content: "<ol><li>Test</li></ol>"}
      expect(Message.count).to eq(1)
    end

    it "should throw an error message if there is no subject" do
      post :create, message: {subject: "", content: "<ol><li>Test</li></ol>"}
      expect(response.request.flash[:error]).to eq("Subject can't be blank")
    end

    it "should redirect to the main message page" do
      @request.env['HTTP_REFERER'] = messages_path
      post :create, message: {subject: "Test", content: "<ol><li>Test</li></ol>"}
      expect(response).to redirect_to(messages_path)
    end

    it "should assign users to the message if it's an email" do
      post :create, message: {subject: "Test", content: "<ol><li>Test</li></ol>", sent: true, delivery_type: "email"}, user_ids: [user.email]
      message = Message.last
      expect(message.users).to_not be_empty
    end

    it "should not assign users to the message if it's a published message" do
      post :create, message: {subject: "Test", content: "<ol><li>Test</li></ol>", sent: false, delivery_type: "published"}, user_ids: [user.email]
      message = Message.last
      expect(message.users).to be_empty
    end

    it "should attach a resource to the message if the resource_id is present & not empty" do
      pending "test needs changing due to... changes to do with S3? ab9e3583c7f5d80d3f7e8895be8bbe8483f1da20"
      resource = FactoryGirl.create(:resource)
      post :create, message: {subject: "Test", content: "<ol><li>Test</li></ol>", sent: false, delivery_type: "published"}, user_ids: [user.email], resource_id: resource.id
      message = Message.last
      expect(message.resources).to_not be_empty
    end

    it "should not attach a resource to the message if the resource_id is present & empty" do
      resource = FactoryGirl.create(:resource)
      post :create, message: {subject: "Test", content: "<ol><li>Test</li></ol>", sent: false, delivery_type: "published"}, user_ids: [user.email], resource_id: ""
      message = Message.last
      expect(message.resources).to be_empty
    end


  end

  xdescribe "#destroy" do
    let(:message) { FactoryGirl.create(:message) }

    it "should delete the message" do
      delete :destroy, id: message.id, format: :js
      expect(response.status).to eq(200)
    end

  end

  describe "#add_recipients_to_message" do
    before(:each) do
      @controller = MessagesController.new
      @controller.instance_variable_set('@message', FactoryGirl.create(:message))
      @user = FactoryGirl.create(:user)

      @contact_list = FactoryGirl.create(:contact_list)
      @user_in_contact_list = FactoryGirl.create(:user, :with_different_email)

      @contact_list.users << @user_in_contact_list
      @user_ids = []
      @contact_list_ids = []
    end

    it "should include one user recipient" do
      @user_ids << @user.email
      email_array = @controller.send("add_recipients_to_message", @user_ids, @contact_list_ids)
      expect(email_array.length).to eq(1)
      expect(email_array.any? {|ea| ea.email == @user.email}).to be true
    end

    it "should include one contact list recipient" do
      @contact_list_ids << @contact_list.id
      email_array = @controller.send("add_recipients_to_message", @user_ids, @contact_list_ids)
      expect(email_array.length).to eq(1)
      expect(email_array.any? {|ea| ea.email == @user_in_contact_list.email}).to be true
    end

    it "should include two recipients (one user and one contact_list)" do
      @user_ids << @user.email
      @contact_list_ids << @contact_list.id
      email_array = @controller.send("add_recipients_to_message", @user_ids, @contact_list_ids)
      expect(email_array.length).to eq(2)
      expect(email_array.any? {|ea| ea.email == @user.email}).to be true
      expect(email_array.any? {|ea| ea.email == @user_in_contact_list.email}).to be true
    end
  end


end
