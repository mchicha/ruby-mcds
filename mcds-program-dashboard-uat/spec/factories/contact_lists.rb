FactoryGirl.define do
  factory :contact_list do
    name "MyString"

	  trait :with_name_abcx do
	    name 'ABCX'
	    user_id 111
	  end

	  trait :with_name_xyz do
	    name "XYZ"
	    user_id 111
	  end
	end

end
