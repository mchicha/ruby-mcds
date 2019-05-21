class CreateDocumentNotes < ActiveRecord::Migration
  def change
    create_table :document_notes do |t|
      t.integer :document_id
      t.integer :note_id
      t.timestamps null: false
    end

    add_index "document_notes", ["document_id", "note_id"], name: "index_document_id_note_id", using: :btree
  end
end
