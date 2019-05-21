class AddDepthCache < ActiveRecord::Migration
  def change
    add_column :geographies, :ancestry_depth, :integer, default: 0
  end
end
