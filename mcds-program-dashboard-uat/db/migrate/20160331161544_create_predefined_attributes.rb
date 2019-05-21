class CreatePredefinedAttributes < ActiveRecord::Migration
  def change
    create_table :predefined_attributes do |t|
      t.string :table
      t.string :column
      t.string :value

      t.integer :send_on
      t.text :values

      t.timestamps
    end
  end
end
