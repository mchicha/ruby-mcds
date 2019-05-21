class AddPrintScaleToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :print_scale, :float, default: 1.0
  end
end
