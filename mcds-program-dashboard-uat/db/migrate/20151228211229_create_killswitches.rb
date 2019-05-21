class CreateKillswitches < ActiveRecord::Migration
  def change
    create_table :killswitches do |t|
      t.string :name
      t.boolean :killed, default: false
      t.string :description
    end
  end
end
