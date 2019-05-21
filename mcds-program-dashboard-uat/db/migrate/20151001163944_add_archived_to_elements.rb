class AddArchivedToElements < ActiveRecord::Migration
  def change
    add_column :elements, :archived, :boolean, default: false
  end
end
