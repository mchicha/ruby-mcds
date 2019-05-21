class CreateEpics < ActiveRecord::Migration
  def change
    create_table :epics do |t|
      t.integer :origin_id
      t.integer :template_id
      t.timestamps
    end
  end
end
