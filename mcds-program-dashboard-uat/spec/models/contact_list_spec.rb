require 'rails_helper'

RSpec.describe ContactList, :type => :model do

  it { should have_many(:users) }
  it { should have_many(:messages).through(:contact_list_messages) }

end
