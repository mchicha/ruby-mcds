class AddPosToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :pos, :text
  end
end
