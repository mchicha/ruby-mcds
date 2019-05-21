class AddCalendarColumnsToDateTypes < ActiveRecord::Migration
  def change
    add_column :date_types, :fa_icon, :string
    add_column :date_types, :icon_color, :string
  end
end
