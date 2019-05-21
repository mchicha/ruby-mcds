class AddElementTypeOf < ActiveRecord::Migration
  def change
    add_column :elements, :type_of, :integer, default: 0
  end
end
