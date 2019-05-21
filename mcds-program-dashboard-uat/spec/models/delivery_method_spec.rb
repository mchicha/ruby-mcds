require 'rails_helper'

RSpec.describe DeliveryMethod, :type => :model do
  it {should have_many(:programs) }
end
