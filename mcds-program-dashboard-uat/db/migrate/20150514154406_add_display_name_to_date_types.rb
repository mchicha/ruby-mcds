class AddDisplayNameToDateTypes < ActiveRecord::Migration
  def up
  	add_column :date_types, :display_name, :string
  	DateType.find_by(name:"pop_install").update(display_name:"POP Install")
  	DateType.find_by(name:"pop_take_down").update(display_name:"POP Take Down")
  end

  def down
  	remove_column :date_types, :display_name
  end
end
