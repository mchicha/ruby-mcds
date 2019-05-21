class AddRequiredToDateTypesTable < ActiveRecord::Migration
  def change
    add_column :date_types, :required, :boolean, default: false

    # update date types
    date_types = DateType.where(name: ["pop_install", "kit_delivery_between", "pop_take_down"])
    date_types.each{|date_type| date_type.update_attributes(required: true) }
  end
end
