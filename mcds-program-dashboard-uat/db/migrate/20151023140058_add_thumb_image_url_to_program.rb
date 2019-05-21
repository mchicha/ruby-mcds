class AddThumbImageUrlToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :thumb_image_url, :string
  end
end
