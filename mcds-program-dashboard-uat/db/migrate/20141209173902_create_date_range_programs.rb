class CreateDateRangePrograms < ActiveRecord::Migration
  def change
    create_join_table :date_ranges, :programs do |t|
      t.index :date_range_id
      t.index :program_id
      t.timestamps
    end
  end
end
