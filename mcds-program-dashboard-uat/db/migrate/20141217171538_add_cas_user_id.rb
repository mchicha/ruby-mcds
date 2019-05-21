class AddCasUserId < ActiveRecord::Migration
  def change
    add_column :users, :cas_user_id, :integer
  end
end
