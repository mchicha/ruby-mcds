class AddSourceIdAndParentIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :source_id, :integer
    add_column :notes, :parent_id, :integer
  end
end
