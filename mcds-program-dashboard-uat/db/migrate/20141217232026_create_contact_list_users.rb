class CreateContactListUsers < ActiveRecord::Migration
  def change
    create_join_table :contact_lists, :users do |t|
      t.index :contact_list_id
      t.index :user_id
      t.timestamps
    end
  end
end
