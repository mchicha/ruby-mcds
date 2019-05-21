class RemoveSchematicsPrograms < ActiveRecord::Migration
  def change
    drop_table :schematics_programs
  end
end
