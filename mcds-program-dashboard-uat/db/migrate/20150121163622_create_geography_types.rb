class CreateGeographyTypes < ActiveRecord::Migration
  def change
    create_table :geography_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :geography_types, :name
    add_column :geographies, :geography_type_id, :integer
  end
end
