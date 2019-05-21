class AddSourceIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :source_id, :integer
  end
end
