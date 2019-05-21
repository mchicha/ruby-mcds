require 'rails_helper'

RSpec.describe ContactListMessage, :type => :model do

	it { should belong_to(:contact_list) }
	it { should belong_to(:message) }

  pending "add some examples to (or delete) #{__FILE__}"
end
