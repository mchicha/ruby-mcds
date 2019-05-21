class AddPrimaryKeyToGeographyProgramTable < ActiveRecord::Migration
  def change
    add_column :geographies_programs, :id, :primary_key
  end
end
