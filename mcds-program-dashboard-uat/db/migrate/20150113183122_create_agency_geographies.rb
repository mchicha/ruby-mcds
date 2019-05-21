class CreateAgencyGeographies < ActiveRecord::Migration
  def change
    create_join_table :agencies, :geographies do |t|
      t.index :agency_id
      t.index :geography_id
      t.timestamps
    end
  end
end
