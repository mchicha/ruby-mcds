class RenameDocumentIdColumnToLayout < ActiveRecord::Migration
  def change
    rename_column :elements, :document_id, :layout_id
  end
end
