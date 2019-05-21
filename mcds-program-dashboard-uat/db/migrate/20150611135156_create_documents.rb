class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string  :name
      t.float   :height
      t.float   :width
      t.integer :type
      t.timestamps
    end
  end
end
