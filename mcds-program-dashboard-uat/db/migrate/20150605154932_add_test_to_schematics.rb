class AddTestToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :sch_type, :integer, default: 0
  end
end
