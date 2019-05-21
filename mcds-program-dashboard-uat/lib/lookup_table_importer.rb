module LookupTableImporter

  def friendly_sheet_parse(sheet)
    result = {}
    friend_sheet = Roo::Spreadsheet.open(sheet, extension: :xlsx).sheet("Sheet1").to_a

    raise "improper row structure for friends sheet" unless friend_sheet[0] == ["Zone", "Template Name", nil, nil, "Friendly Name", "Trim Size"]

    friend_sheet[1..-1].each do |row|
      next unless row[1] #Skip the rows that are only a header

      template_name = row[1].downcase.rstrip.lstrip

      result[template_name] = {'Zone' => row[0], 'Element Name' => row[4], 'Size' => row[5]}
    end
    result
  end

  def position_sheets_parse(sheets)
    result = {}
    position_sheets = Roo::Spreadsheet.open(sheets, extension: :xlsx)

    position_sheets.sheets.each do |sub_sheet|
      current_sheet = position_sheets.sheet(sub_sheet).to_a

      current_sheet.each_with_index do |row, index|
        # skip information rows
        next if row[0] == "ZONE:" || row[0] == "Illustrator Filename:" || row[0] == "Position ID"

        # skip blank rows and placeholder position_id rows
        next if row.compact.length < 2

        # standardize casing
        template_name = row[1].downcase.rstrip.lstrip

        # skip rows irrelevant to importing assets in the dam

        next if template_name.match(/\.ai/)
        next if template_name == "container" || template_name == "slot would remain empty for dte"
        next if row[2] && row[2].downcase.rstrip.lstrip == "container"

        postion_id = row[0]

        if !postion_id
          look_back_index = index

          while look_back_index > 0 && postion_id.nil?
            look_back_index -=1
            postion_id = current_sheet[look_back_index][0]
          end
        end

        postion_id = postion_id.to_s

        depth_variable = nil

        if postion_id.match(/b/)
          depth_variable = 'back'
        elsif postion_id.match(/f/)
          depth_variable = 'front'
        end

         postion_id.gsub!(/[a-z]/, '')

        if result[template_name]
          result[template_name]['Position Ids'] << postion_id
        else
          result[template_name] = {'Position Name' => row[2], 'Position Ids' => [postion_id]}
        end

        if depth_variable
          result[template_name]['Depth'] = depth_variable
        end

      end
    end
    result
  end

  def import_spreadsheet(opts = {})

    if opts[:table_name].downcase == 'friendly'
      result_hash = friendly_sheet_parse(opts[:spreadsheet])
    elsif opts[:table_name].downcase == 'position'
      result_hash = position_sheets_parse(opts[:spreadsheet])
    end

    new_table = LookupTable.create(key_field_name: opts[:key_field_name], table_name: opts[:table_name])

    result_hash.each do |key, value|
      new_row = new_table.lookup_table_rows.create

      new_row.key = key
      new_row.columns = value

      new_row.save
    end
  end
end
