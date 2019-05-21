FactoryGirl.define do

  factory :resource do
    description   Faker::Lorem.sentence
    file          Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/ronald-mcdonald-96.jpg')))

    trait :with_program do
      resourceable {FactoryGirl.create(:program, :with_geographies)}
    end

  end

  factory :bad_resource, :class => Resource do
    description   Faker::Lorem.sentence
    file          Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/SAMLResponse.xml')))
  end


end
