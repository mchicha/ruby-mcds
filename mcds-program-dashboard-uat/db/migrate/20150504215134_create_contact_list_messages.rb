class CreateContactListMessages < ActiveRecord::Migration
  def change
    create_table :contact_list_messages do |t|
    	t.integer :message_id
      t.integer :contact_list_id

      t.timestamps
    end
  end
end
