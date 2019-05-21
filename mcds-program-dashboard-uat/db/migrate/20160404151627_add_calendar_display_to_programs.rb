class AddCalendarDisplayToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :calendar_display, :integer, default: 0
  end
end
