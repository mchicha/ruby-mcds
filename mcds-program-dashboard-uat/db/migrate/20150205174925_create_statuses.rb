class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name

      t.timestamps
    end
    add_column :programs, :status_id, :integer
  end
end
