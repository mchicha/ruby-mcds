class AddBackAssetIdToElements < ActiveRecord::Migration
  def change
    add_column :elements, :secondary_dam_asset_id, :integer, limit: 4
    add_column :elements, :secondary_dam_asset_path, :string, limit: 255
  end
end
