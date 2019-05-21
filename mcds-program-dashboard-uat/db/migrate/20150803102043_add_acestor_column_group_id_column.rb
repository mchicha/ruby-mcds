class AddAcestorColumnGroupIdColumn < ActiveRecord::Migration
  def change
    add_column :documents, :values, :text
  end
end
