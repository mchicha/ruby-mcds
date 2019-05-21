FactoryGirl.define do
  factory :program do
    name Faker::Name.name
    number Faker::Number.number(5)
    user factory: :user
    delivery_method factory: :delivery_method

    trait :user_with_geography do
      user factory: [:user, :with_geography]
    end

    trait :with_geographies do
      geographies {[FactoryGirl.create(:geography)]}
    end

    trait :with_geographies_associated_to_agency do
      geographies {[FactoryGirl.create(:geography, :with_agency)]}
    end

    trait :assigned_to_national do
      geographies {[FactoryGirl.create(:geography, :national)]}
    end

    trait :last_updated do
      updated_at Date.strptime("11/02/2014", "%m/%d/%Y")
    end

    trait :pop_install_dates do
      date_ranges {[FactoryGirl.create(:date_range, :pop_install_range, start_date: Date.today, end_date: Date.today + 5)]}
    end

    trait :far_away_pop_install_dates do
      date_ranges {[FactoryGirl.create(:date_range, :pop_install_range, start_date: Date.today + 500, end_date: Date.today + 505)]}
    end

    trait :kit_delivery_between do
      date_ranges {[FactoryGirl.create(:date_range, :kit_delivery_between)]}
    end

    trait :with_color_blocks do
      color_blocks {[FactoryGirl.create(:color_block)]}
    end

    trait :with_specific_name do
      name "Fake Program"
    end

    trait :has_resource do
      resources {[FactoryGirl.create(:resource)]}
    end

  end


end
