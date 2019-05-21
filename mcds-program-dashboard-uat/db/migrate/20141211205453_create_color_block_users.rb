class CreateColorBlockUsers < ActiveRecord::Migration
  def change
    create_join_table :color_blocks, :users do |t|
      t.index :color_block_id
      t.index :user_id
      t.timestamps
    end
  end
end
