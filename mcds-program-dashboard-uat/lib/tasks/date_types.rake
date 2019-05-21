namespace :date_types do

  date_types = [:pop_install, :pop_take_down, :product_in_store]

  date_types.each do |date_type|
    task "update_#{date_type}" => :environment do
      dt = DateType.find_by_name(date_type)
      dt.end_date_required = true
      dt.save
      puts "#{date_type.to_s.humanize} date type updated."
    end
  end

end
