class AddSourceId < ActiveRecord::Migration
  def change
    add_column :schematics, :source_id, :integer
  end
end
