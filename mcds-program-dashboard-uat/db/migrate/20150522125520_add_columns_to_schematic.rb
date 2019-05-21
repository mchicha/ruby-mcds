class AddColumnsToSchematic < ActiveRecord::Migration
  def change
    add_column :schematics, :parent_id, :integer
    add_column :schematics, :epic_id, :integer
  end
end
