class AddBackgroundToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :background, :string
  end
end
