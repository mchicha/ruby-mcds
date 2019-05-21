class AddCoopIdToGeographies < ActiveRecord::Migration
  def change
    add_column :geographies, :coop_id, :integer
    Geography.all.map do |a|
      GeographyType.find_by(name: "REGION").geographies.find_each do |region|
        region_id = region.name[/\d+/]
        region.update_attributes(coop_id: region_id)
      end

      GeographyType.find_by(name: "COOP").geographies.find_each do |co_op|
        co_op_id = co_op.name[/\d+/]
        co_op.update_attributes(coop_id: co_op_id)
      end
    end
  end
end
