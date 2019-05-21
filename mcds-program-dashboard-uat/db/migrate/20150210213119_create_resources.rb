class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.text :description
      t.string :file
      t.integer :program_id
      t.timestamps
    end
  end
end
