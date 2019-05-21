class AddGrayscaleToElements < ActiveRecord::Migration
  def change
    add_column :elements, :grayscale, :boolean, default: false
  end
end
