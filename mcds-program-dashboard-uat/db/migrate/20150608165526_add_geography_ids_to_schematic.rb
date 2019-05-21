class AddGeographyIdsToSchematic < ActiveRecord::Migration
  def change
    add_column :schematics, :geography_ids, :text
  end
end
