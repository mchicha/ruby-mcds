FactoryGirl.define do
  factory :lookup_table_row do
    key 'Road_Side_Banner'
    columns ({:zone=>"Exterior", :friendly_name=>"Road Side Banner", :trim_size=>"13' x 2.743' iecut", :position_name=>"Road Side Banner", :position_ids=>["1.2"]})
  end
end
