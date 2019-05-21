require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do

  describe "load_token" do

    let(:user) { FactoryGirl.create(:user, role: User.roles[:tukaiz_super_admin]) }

    it "should look for a wkhtmltopdf token" do
      # **************
      pending 'wkhtmltopdf is not currently active'
      # ***********

      user
      allow(request).to receive(:headers).and_return({'HTTP_PDF_TOKEN' => ENV['WKHTML_ACCESS_TOKEN']})
      subject.load_token
      expect(session[:user_id]).to eq(user.id)
    end
  end

end
