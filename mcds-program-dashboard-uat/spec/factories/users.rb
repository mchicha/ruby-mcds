FactoryGirl.define do
  factory :user do
    first_name "First"
    last_name "Last"

    sequence :email do |n|
      "blah@blah.com"
    end

    trait :with_geography do
      geographies {[FactoryGirl.create(:geography)]}
    end

    trait :created_programs do
      programs {[FactoryGirl.create(:program, :with_geographies)]}
    end

    trait :no_last_name do
      last_name nil
    end

    trait :with_cas_id do
      cas_user_id 1
    end

    trait :with_different_email do
      first_name "Second"
      last_name "Penultimate"
      email "happy@days.com"
    end
  end


end
