FactoryGirl.define do
  factory :agency do
    name "MyString"
  end

  trait :with_geographies do
    geographies {[FactoryGirl.create(:geography)]}
  end

  trait :with_users do
    users {[FactoryGirl.create(:user)]}
  end


end
