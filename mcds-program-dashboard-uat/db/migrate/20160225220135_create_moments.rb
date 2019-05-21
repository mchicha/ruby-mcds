class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.string :title
      t.boolean :archived, default: false
      t.text :body
      t.date :post_date
      t.date :remove_date


      t.string :momentable_type
      t.integer :momentable_id

      t.integer :user_id

      t.boolean :show_all, default: false

      t.timestamps
    end

    add_index :moments, :momentable_id
    add_index :moments, :momentable_type
  end
end
