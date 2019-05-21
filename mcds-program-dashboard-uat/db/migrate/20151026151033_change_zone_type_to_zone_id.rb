class ChangeZoneTypeToZoneId < ActiveRecord::Migration
  def up
    rename_column :documents, :zone_type, :zone_id
  end

  def down
    rename_column :documents, :zone_id, :zone_type
  end
end
