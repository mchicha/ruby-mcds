require 'rails_helper'

RSpec.describe GeographyMessage, :type => :model do

  it { should belong_to(:message) }
  it { should belong_to(:geography) }

end
