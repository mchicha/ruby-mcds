class CreateDeliveryMethods < ActiveRecord::Migration
  def change
    create_table :delivery_methods do |t|
      t.string :name

      t.timestamps
    end
    add_column :programs, :delivery_method_id, :integer
  end
end
