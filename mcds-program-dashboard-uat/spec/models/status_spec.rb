require 'rails_helper'

RSpec.describe Status, :type => :model do
  it {should have_many(:programs) }
end
