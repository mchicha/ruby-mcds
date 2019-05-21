class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.text :body
      t.float :x, default: 0
      t.float :y, default: 0
      t.float :width
      t.float :height
      t.timestamps null: false
    end
  end
end
