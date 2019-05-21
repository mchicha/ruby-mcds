class AddSortOrderToDateTypes < ActiveRecord::Migration
  def change
    add_column :date_types, :sort_order, :integer, default: 1

    DateType.find_by(name: "kit_delivery_between").update_attributes(sort_order: 1)
    DateType.find_by(name: "pop_install").update_attributes(sort_order: 2)
    DateType.find_by(name: "advertised_start").update_attributes(sort_order: 3)
    DateType.find_by(name: "pop_take_down").update_attributes(sort_order: 4)
    DateType.find_by(name: "product_in_store").update_attributes(sort_order: 5)
    DateType.find_by(name: "soft_sell_start_between").update_attributes(sort_order: 6)
    DateType.find_by(name: "all_store_sell").update_attributes(sort_order: 7)
    DateType.find_by(name: "product_phase_out").update_attributes(sort_order: 8)
    DateType.find_by(name: "archive_program_on").update_attributes(sort_order: 9)


  end
end
