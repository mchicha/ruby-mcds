class CreateDocumentElements < ActiveRecord::Migration
  def change
    create_table :document_elements do |t|
      t.integer :document_id
      t.integer :element_id
      t.timestamps
    end

    add_column :elements, :source_id, :integer

  end
end
