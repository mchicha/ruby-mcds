class CreateAlertGeographies < ActiveRecord::Migration
  def change
    create_table :alert_geographies do |t|
      t.integer :alert_id
      t.integer :geography_id

      t.timestamps
    end

    add_index :alert_geographies, :alert_id
    add_index :alert_geographies, :geography_id
  end
end
