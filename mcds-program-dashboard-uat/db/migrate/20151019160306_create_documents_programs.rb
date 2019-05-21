class CreateDocumentsPrograms < ActiveRecord::Migration
  def change
    create_table :documents_programs do |t|
      t.belongs_to :document, index: true, foreign_key: true
      t.belongs_to :program, index: true, foreign_key: true
      t.belongs_to :element, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
