require 'rails_helper'

RSpec.describe Geography, :type => :model do

  it { should have_many(:programs).through(:geography_program) }
  it {should belong_to(:geography_type) }
  it { should have_many(:messages).through(:geography_messages) }

end
