class FixContactListSchema < ActiveRecord::Migration
  def up
    add_column :contact_lists, :user_id, :integer
    rename_table :contact_lists_users, :contact_list_users
    add_column :contact_list_users, :id, :primary_key
  end

  def down
    remove_column :contact_lists, :user_id
    remove_column :contact_list_users, :id
    rename_table :contact_list_users, :contact_lists_users
  end

end
