FactoryGirl.define do
  factory :date_range do
    start_date Date.strptime("01/01/2013", "%m/%d/%Y")
    end_date Date.strptime("12/24/2014", "%m/%d/%Y")

    trait :pop_install do
      end_date ""
      date_type {FactoryGirl.create(:date_type, :pop_install_type)}
    end

    trait :kit_delivery_between do
      date_type {FactoryGirl.create(:date_type, :kit_delivery_between_type)}
    end

    trait :pop_install_range do
      date_type {FactoryGirl.create(:date_type, :pop_install_type)}
    end

  end

end
