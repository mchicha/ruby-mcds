class CreateDocumentSchematics < ActiveRecord::Migration
  def change
    create_table :document_schematics do |t|
      t.integer :schematic_id
      t.integer :document_id
      t.integer :element_id
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
