class AddGeographyIdToElementAndDocument < ActiveRecord::Migration
  def change
    add_column :document_elements, :geography_id, :integer
    add_column :document_schematics, :geography_id, :integer
  end
end
