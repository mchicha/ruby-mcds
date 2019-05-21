class CreateColorBlockPrograms < ActiveRecord::Migration
  def change
    create_join_table :color_blocks, :programs do |t|
      t.index :color_block_id
      t.index :program_id
      t.timestamps
    end
  end
end
