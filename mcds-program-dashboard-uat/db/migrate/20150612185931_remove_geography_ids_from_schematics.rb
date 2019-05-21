class RemoveGeographyIdsFromSchematics < ActiveRecord::Migration
  def change
    remove_column :schematics, :geography_ids
  end
end
