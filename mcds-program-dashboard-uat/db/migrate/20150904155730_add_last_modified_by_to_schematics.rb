class AddLastModifiedByToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :last_modified_by_id, :integer
  end
end
