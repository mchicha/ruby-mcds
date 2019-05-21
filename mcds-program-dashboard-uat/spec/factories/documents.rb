FactoryGirl.define do
  factory :document do
    name      { Faker::Name.name }
    height    { Random.new.rand(2000..6000) }
    width     { Random.new.rand(2000..6000) }
    type_of   { Random.new.rand(0..2) }
    filename  { "#{Faker::Name.name.parameterize}.svg" }
    values    { { height: 100, width: 100} }

    trait :with_notes do
      after(:create) { |document, note|
          document.notes = FactoryGirl.create_list(:note, 2)
      }
    end
  end
end
