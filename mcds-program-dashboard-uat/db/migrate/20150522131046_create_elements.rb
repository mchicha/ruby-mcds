class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.string :name
      t.integer :zindex
      t.boolean :editable, default: true
      t.string :identity
      t.integer :parent_id
      t.timestamps
    end
  end
end
