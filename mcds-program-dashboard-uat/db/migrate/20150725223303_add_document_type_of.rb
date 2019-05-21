class AddDocumentTypeOf < ActiveRecord::Migration
  def change
    add_column :documents, :type_of, :integer, default: 0
  end
end
