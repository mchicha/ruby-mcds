class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :title
      t.boolean :archived, default: false
      t.text :body
      t.date :post_date
      t.date :remove_date

      t.string :alertable_type
      t.integer :alertable_id

      t.integer :user_id

      t.timestamps
    end

    add_index :alerts, :alertable_id
    add_index :alerts, :alertable_type
  end
end
