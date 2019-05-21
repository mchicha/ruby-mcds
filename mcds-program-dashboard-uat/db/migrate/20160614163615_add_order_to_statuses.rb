class AddOrderToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :sort_order, :integer, default: 0
  end
end
