class AddRelationshipForSchematicAndStatus < ActiveRecord::Migration
  def change
    add_column :schematics, :status, :integer
  end
end
