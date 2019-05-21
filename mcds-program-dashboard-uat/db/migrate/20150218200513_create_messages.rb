class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :content
      t.boolean :sent, default: false
      t.datetime :send_date
      t.boolean :publish, default: false
      t.datetime :publish_date
      t.datetime :archive_date
      t.string :delivery_type
      t.integer :user_id

      t.timestamps
    end
  end
end
