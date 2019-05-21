class CreateAgencyUsers < ActiveRecord::Migration
  def change
    create_join_table :agencies, :users do |t|
      t.index :agency_id
      t.index :user_id
      t.timestamps
    end
  end
end
