class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    add_column :users, :role_id, :integer
  end
end
