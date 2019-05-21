class CreateLookupTables < ActiveRecord::Migration
  def change
    create_table :lookup_tables do |t|
      t.string    :table_name
      t.string    :key_field_name
      t.boolean   :archived, default: false

      t.timestamps
    end
  end
end
