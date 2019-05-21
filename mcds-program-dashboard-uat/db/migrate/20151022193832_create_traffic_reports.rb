class CreateTrafficReports < ActiveRecord::Migration
  def change
    create_table :traffic_reports do |t|
      t.integer :incident_type
      t.boolean :archived, default: false
      t.boolean :seen, default: false
      t.text :body

      t.timestamps
    end
  end
end
