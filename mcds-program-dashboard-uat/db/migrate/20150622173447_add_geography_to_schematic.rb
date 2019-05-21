class AddGeographyToSchematic < ActiveRecord::Migration
  def change
    add_column :schematics, :geography_id, :integer
  end
end
