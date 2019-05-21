class CreateSchematicsGeographies < ActiveRecord::Migration
  def change
    create_table :schematics_geographies do |t|

      t.integer :schematic_id
      t.integer :geography_id

      t.timestamps
    end

    add_index :schematics_geographies, [:schematic_id, :geography_id]
  end
end
