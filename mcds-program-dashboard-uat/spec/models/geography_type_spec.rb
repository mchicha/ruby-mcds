require 'rails_helper'

RSpec.describe GeographyType, :type => :model do

  it { should have_many(:geographies) }

end
