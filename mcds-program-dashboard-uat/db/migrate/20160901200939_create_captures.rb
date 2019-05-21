class CreateCaptures < ActiveRecord::Migration
  def change
    create_table :captures do |t|
      t.string  :event
      t.integer :user_id
      t.string  :session_id
      t.integer :user_role
      t.text    :data
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
