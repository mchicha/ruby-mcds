class DropArchivedFromDocuments < ActiveRecord::Migration
  def up
    remove_column :documents, :archived
  end

  def down
    add_column :documents, :archived, :boolean
  end
end
