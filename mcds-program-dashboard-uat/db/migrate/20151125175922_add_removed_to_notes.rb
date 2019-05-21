class AddRemovedToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :removed, :boolean, default: false
  end
end
