class AddSelectedGeorgraphyIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :selected_geography_id, :integer
  end
end
