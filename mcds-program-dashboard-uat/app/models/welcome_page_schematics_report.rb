class WelcomePageSchematicsReport
  attr_accessor :rows

  def initialize(schematics)
    @rows = []
    create_rows(schematics)
    sort_rows
  end

  def create_rows(schematics)
    schematics.each do |schematic|
      if schematic.parent_id.present?
        existing_parent_report = rows.select{|row| row.parent.try(:id) == schematic.parent_id}

        if existing_parent_report.length > 0
          existing_parent_report.first.children << schematic
        else
          rows << WelcomePageSchematicsReportRow.new(parent: schematic.parent, children: [schematic])
        end
      else
        rows << WelcomePageSchematicsReportRow.new(parent: schematic)
      end
    end
  end

  def sort_rows
    rows.each{|row| row.sort_children}
  end
end
