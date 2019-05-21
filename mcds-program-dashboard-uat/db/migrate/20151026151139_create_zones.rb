class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name
      t.integer :sort_order
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
