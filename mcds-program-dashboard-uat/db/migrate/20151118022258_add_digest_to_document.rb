class AddDigestToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :digest, :string
  end
end
