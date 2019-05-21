class AddNotesToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :notes, :text
  end
end
