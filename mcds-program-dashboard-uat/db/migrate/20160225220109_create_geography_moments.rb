class CreateGeographyMoments < ActiveRecord::Migration
  def change
    create_table :geography_moments do |t|
      t.integer :geography_id
      t.integer :moment_id

      t.timestamps
    end

    add_index :geography_moments, :moment_id
    add_index :geography_moments, :geography_id
  end
end
