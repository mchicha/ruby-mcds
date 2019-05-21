class RemoveElementIdFromSchematicsProgram < ActiveRecord::Migration
  def change
    remove_foreign_key :schematics_programs, :element
    remove_reference :schematics_programs, :element, index: true
  end
end
