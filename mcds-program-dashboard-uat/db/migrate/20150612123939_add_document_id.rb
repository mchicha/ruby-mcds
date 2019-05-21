class AddDocumentId < ActiveRecord::Migration
  def change
    add_column :elements, :document_id, :integer
    add_column :elements, :values, :text
  end
end
