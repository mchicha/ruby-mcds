class CreateDateTypes < ActiveRecord::Migration
  def up
    create_table :date_types do |t|
      t.string :name
      t.timestamps
    end

    DateType.find_or_create_by(name: "kit_delivery_between")
		DateType.find_or_create_by(name: "pop_install")
		DateType.find_or_create_by(name: "advertised_start")
		DateType.find_or_create_by(name: "pop_take_down")
		DateType.find_or_create_by(name: "product_in_store")
		DateType.find_or_create_by(name: "soft_sell_start_between")
		DateType.find_or_create_by(name: "all_store_sell")
		DateType.find_or_create_by(name: "product_phase_out")
		DateType.find_or_create_by(name: "archive_program_on")
  end

  def down
  	drop_table :date_types
  end
end
