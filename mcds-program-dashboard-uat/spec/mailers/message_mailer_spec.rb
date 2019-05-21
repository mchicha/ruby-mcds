require "rails_helper"

RSpec.describe MessageMailer, :type => :mailer do

  let(:message) { FactoryGirl.create(:message, :that_has_recipients) }

  describe "#send_message" do
    before(:each) do
      users = message.users.collect(&:email)
      @mailer = MessageMailer.send_message(message, users)
    end

    it "should have the subject of Test Subject" do
      expect(@mailer.subject).to eq("Test Subject")
    end

    it "should have at least 1 recipient" do
      expect(@mailer.bcc.count).to eq(1)
    end

    it "should show the sender as being the user who created the message" do
      expect(@mailer.from).to eq(['no-reply@mcsourceonline.com'])
    end

  end



end
