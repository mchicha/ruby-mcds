class CreateGeographyPrograms < ActiveRecord::Migration
  def change
    create_join_table :geographies, :programs do |t|
      t.index :geography_id
      t.index :program_id
    end
  end
end
