class CreateDocumentables < ActiveRecord::Migration
  def change
    create_table :documentables do |t|

      t.timestamps
    end
  end
end
