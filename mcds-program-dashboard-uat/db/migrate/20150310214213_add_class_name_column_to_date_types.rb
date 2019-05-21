class AddClassNameColumnToDateTypes < ActiveRecord::Migration
  def change
    add_column :date_types, :class_name, :string

    DateType.find_by(name: "kit_delivery_between").update_attributes(class_name: "lighter")
    DateType.find_by(name: "pop_install").update_attributes(class_name: "shaded")
    DateType.find_by(name: "advertised_start").update_attributes(class_name: "shaded")
    DateType.find_by(name: "pop_take_down").update_attributes(class_name: "shaded")
    DateType.find_by(name: "product_in_store").update_attributes(class_name: "lighter")
    DateType.find_by(name: "soft_sell_start_between").update_attributes(class_name: "lighter")
    DateType.find_by(name: "all_store_sell").update_attributes(class_name: "lighter")
    DateType.find_by(name: "product_phase_out").update_attributes(class_name: "lighter")
    DateType.find_by(name: "archive_program_on").update_attributes(class_name: "shaded")

  end
end
