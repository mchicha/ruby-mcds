class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.string :number
      t.integer :user_id
      t.timestamps
    end
  end
end
