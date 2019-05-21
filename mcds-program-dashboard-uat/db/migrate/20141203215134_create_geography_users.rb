class CreateGeographyUsers < ActiveRecord::Migration
  def change
    create_table :geographies_users do |t|
      t.integer :geography_id, :integer
      t.integer :user_id, :integer
      t.index :geography_id
      t.index :user_id
      t.timestamps
    end
  end
end
