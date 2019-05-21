class AddShowAllToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :show_all, :boolean
  end
end
