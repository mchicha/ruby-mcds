FactoryGirl.define do
  factory :geography do
    name Faker::Address.city

    trait :national do
      name "National"
    end

    trait :with_agency do
      agencies {[FactoryGirl.create(:agency)]}
    end

  end

end
