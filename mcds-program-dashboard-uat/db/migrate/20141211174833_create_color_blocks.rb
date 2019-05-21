class CreateColorBlocks < ActiveRecord::Migration
  def change
    create_table :color_blocks do |t|
      t.string :name
      t.string :start_hex
      t.string :end_hex

      t.timestamps
    end
  end
end
