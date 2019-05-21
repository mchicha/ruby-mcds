class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :epic_id
      t.timestamps
    end
  end
end
