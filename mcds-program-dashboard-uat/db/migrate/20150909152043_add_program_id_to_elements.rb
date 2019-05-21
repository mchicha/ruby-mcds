class AddProgramIdToElements < ActiveRecord::Migration
  def change
    add_reference :elements, :program, index: true, foreign_key: true
  end
end
