class CreateSchematics < ActiveRecord::Migration
  def change
    create_table :schematics do |t|
      t.string :name
      t.date :release_date
      t.date :end_date
      t.timestamps
    end
  end
end
