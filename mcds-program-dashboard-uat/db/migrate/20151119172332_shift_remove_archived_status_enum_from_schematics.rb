class ShiftRemoveArchivedStatusEnumFromSchematics < ActiveRecord::Migration
  def change
    # Archived was removed as enum, all archived schematics must be taken off this or code breaks
    Schematic.where(status: 2).update_all(status: 1)
  end
end
