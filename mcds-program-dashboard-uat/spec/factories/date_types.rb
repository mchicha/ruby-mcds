FactoryGirl.define do
  factory :date_type do
    name Faker::Name.name
    sort_order 1

    trait :with_class_name do
      class_name "test"
    end

    trait :pop_install_type do
      name "pop_install"
    end

    trait :kit_delivery_between_type do
      name "kit_delivery_between"
    end

  end

end
