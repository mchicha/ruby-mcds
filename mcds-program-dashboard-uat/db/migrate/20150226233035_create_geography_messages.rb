class CreateGeographyMessages < ActiveRecord::Migration
  def change
    create_table :geography_messages do |t|
      t.integer :geography_id
      t.integer :message_id

      t.timestamps
    end
  end
end
