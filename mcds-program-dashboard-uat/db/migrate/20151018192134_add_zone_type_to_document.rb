class AddZoneTypeToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :zone_type, :string
  end
end
