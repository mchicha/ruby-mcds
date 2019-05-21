FactoryGirl.define do
  factory :schematic do |s|
    s.name          { Faker::Commerce.product_name }
    s.release_date  { Faker::Date.forward(14) }
    s.end_date      { Faker::Date.forward(30) }
  end

end
