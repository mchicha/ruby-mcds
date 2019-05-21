class AddDefaultSortOrderToZone < ActiveRecord::Migration
  def up
    change_column :zones, :sort_order, :integer, :default => 1
  end

  def down
    change_column :zones, :sort_order, :integer, :default => nil
  end
end
