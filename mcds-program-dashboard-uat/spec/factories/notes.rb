FactoryGirl.define do
  factory :note do
    name    { Faker::Name.name }
    body    { Faker::Lorem.paragraphs(2) }
    x       { Random.new.rand(2000..6000)}
    y       { Random.new.rand(2000..6000)}
    width   { Random.new.rand(2000..6000)}
    height  { Random.new.rand(2000..6000)}
  end

end
