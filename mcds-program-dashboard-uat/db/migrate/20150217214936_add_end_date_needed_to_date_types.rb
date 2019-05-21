class AddEndDateNeededToDateTypes < ActiveRecord::Migration
  def change
    add_column :date_types, :end_date_required, :boolean, default: false
    names = %w(kit_delivery_between soft_sell_start_between product_phase_out)
    DateType.where(name: names).each do |date_type|
      date_type.update_attributes(end_date_required: true)
    end
  end
end
