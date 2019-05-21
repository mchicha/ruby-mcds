class ChangePopInstallDateToSingleDate < ActiveRecord::Migration
  def change
    date_ranges = DateRange.where("date_type_id = 1")
    date_ranges.each{|dr| dr.update_attributes(end_date: nil)}
  end
end
