class CreateDateRanges < ActiveRecord::Migration
  def change
    create_table :date_ranges do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer  :date_type_id
      t.timestamps
    end
  end
end
