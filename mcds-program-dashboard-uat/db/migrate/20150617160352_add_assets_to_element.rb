class AddAssetsToElement < ActiveRecord::Migration
  def change
    add_column :elements, :dam_asset_id, :integer
    add_column :elements, :dam_asset_path, :string
  end
end
