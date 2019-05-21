class IncreaseColumnSize < ActiveRecord::Migration
  def up
    change_column :elements, :values, :text, limit: 16777215
  end

  def down
    change_column :elements, :values, :text, limit: 65535
  end
end
