class AddLayorName < ActiveRecord::Migration
  def change
    add_column :elements, :layer_name, :string
  end
end
