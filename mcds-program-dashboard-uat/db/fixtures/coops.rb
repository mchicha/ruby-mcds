# Make sure formatting matches...also check new excel workbooks for what they name the sheets and how many there are, this takes the first one.

excel_sheet = Roo::Excelx.new(File.join(Rails.root, 'db/xlsx/McDonalds_CoOp_List.xlsx'))
# create the geography types from the header row (skipping store #)
excel_sheet.row(1).each_with_index do |header, i|
  # skip over store #
  if (excel_sheet.row(1).count-1) != i
    geography_type = GeographyType.find_or_create_by(name: header)
  end
end

2.upto(excel_sheet.last_row).each do |row|
  # Zone is column A
  # Region is column B
  # Co-op is column C & D combined

  # Zone (highest level)
  zone_type = GeographyType.find_by(name: "ZONE")
  if zone_type
    zone = zone_type.geographies.find_or_create_by(name: excel_sheet.cell(row, "A"))
  end

  # Region
  region_type = GeographyType.find_by(name: "REGION")
  if region_type
    region_id = excel_sheet.cell(row, "B")[/\d+/]
    region = Geography.find_or_create_by(coop_id: region_id, geography_type_id: region_type.id)

    region.parent = zone
    region.save

    region.update_attributes(name: excel_sheet.cell(row, "B"))
  end

  # Co-op
  co_op_type = GeographyType.find_by(name: "COOP")
  if co_op_type
    coop_id = excel_sheet.cell(row, "C").to_i
    co_op = Geography.find_or_create_by(coop_id: coop_id, geography_type_id: co_op_type.id)

    co_op.parent = region
    co_op.save

    co_op_name = "#{excel_sheet.cell(row, "C").to_i} - #{excel_sheet.cell(row, "D")}"
    co_op.update_attributes(name: co_op_name)
  end

end
