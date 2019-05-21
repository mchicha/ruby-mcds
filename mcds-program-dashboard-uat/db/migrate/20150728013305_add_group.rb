class AddGroup < ActiveRecord::Migration
  def change
    add_column :elements, :group, :string
  end
end
