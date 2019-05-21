class DropArchivedFromElements < ActiveRecord::Migration
  def up
    remove_column :elements, :archived
  end

  def down
    add_column :elements, :archived, :boolean
  end
end
