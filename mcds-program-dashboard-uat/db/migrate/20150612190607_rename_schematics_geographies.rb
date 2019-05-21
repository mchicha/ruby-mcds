class RenameSchematicsGeographies < ActiveRecord::Migration
  def self.up
    rename_table :schematics_geographies, :geographies_schematics
  end

  def self.down
    rename_table :geographies_schematics, :schematics_geographies
  end
end
