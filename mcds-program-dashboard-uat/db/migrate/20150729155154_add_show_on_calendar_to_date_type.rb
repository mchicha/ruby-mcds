class AddShowOnCalendarToDateType < ActiveRecord::Migration
  def change
    add_column :date_types, :show_on_calendar, :boolean, default: false
    DateType.where(name: ['pop_install', 'pop_take_down']).each {|date_type| date_type.update_attributes(show_on_calendar: true)}
  end
end

