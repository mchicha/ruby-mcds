class AddReportIdToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :report_id, :string
  end
end
