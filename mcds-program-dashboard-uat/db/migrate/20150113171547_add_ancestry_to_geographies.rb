class AddAncestryToGeographies < ActiveRecord::Migration
  def up
    add_column :geographies, :ancestry, :string
    add_index :geographies, :ancestry
  end

  def down
    remove_index :geographies, :ancestry
    remove_column :geographies, :ancestry
  end

end
