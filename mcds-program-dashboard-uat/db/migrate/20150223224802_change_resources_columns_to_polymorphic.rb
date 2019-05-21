class ChangeResourcesColumnsToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :resources, :program_id, :resourceable_id
    add_column :resources, :resourceable_type, :string
    Resource.reset_column_information
    Resource.update_all(resourceable_type: "Program")
  end

  def down
    rename_column :resources, :resourceable_id, :program_id
    remove_column :resources, :resourceable_type
  end
end
