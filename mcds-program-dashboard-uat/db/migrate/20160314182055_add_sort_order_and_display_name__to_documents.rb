class AddSortOrderAndDisplayNameToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :sort_order, :integer, default: 1
    add_column :documents, :display_name, :string
  end
end
