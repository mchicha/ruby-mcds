require 'rails_helper'

RSpec.describe Message, :type => :model do

  it { should belong_to(:user) }
  it { should have_many(:users).through(:message_users) }
  it { should have_many(:geographies).through(:geography_messages) }
  it { should have_many(:contact_lists).through(:contact_list_messages)}

  describe "#send_email" do
    before(:each) do
      @message = FactoryGirl.create(:message, :that_has_recipients)
    end

    it "should send out an email to the recipients" do
      expect { @message.send_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

  end

  describe "#self.find_and_send_all_unsent_messages" do
    before(:each) do
      @message = FactoryGirl.create(:message, :that_has_recipients)
    end

    it "should send messages if it finds unsent messages (published/email)" do
      expect { Message.find_and_send_all_unsent_messages }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "should update the message record to be marked as sent" do
      Message.find_and_send_all_unsent_messages; @message.reload;
      expect(@message.sent).to eq(true)
    end

  end

  describe "#self.remove_scheduled_messages" do

    it "should remove the message from the available messages to see" do
      @message = FactoryGirl.create(:message)
      Message.remove_scheduled_messages; @message.reload;
      expect(@message.archived).to eq(true)
    end

  end

end
