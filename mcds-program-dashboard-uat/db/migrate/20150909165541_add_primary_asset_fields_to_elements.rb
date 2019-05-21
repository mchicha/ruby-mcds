class AddPrimaryAssetFieldsToElements < ActiveRecord::Migration
  def change
    rename_column :elements, :dam_asset_id, :primary_dam_asset_id
    rename_column :elements, :dam_asset_path, :primary_dam_asset_path
    remove_foreign_key :elements, :program
    remove_reference :elements, :program, index: true
    add_column :elements, :primary_program_id, :integer, index: true
    add_column :elements, :secondary_program_id, :integer, index: true
  end
end
