class CreateLookupTableRows < ActiveRecord::Migration
  def change
    create_table :lookup_table_rows do |t|
      t.string    :key
      t.boolean   :archived, default: false
      t.integer   :lookup_table_id
      t.text      :columns

      t.timestamps
    end
  end
end
