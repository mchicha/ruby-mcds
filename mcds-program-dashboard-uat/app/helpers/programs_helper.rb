module ProgramsHelper

  def format_calendar_date(date = DateTime.new)
    date.strftime('%D')
  end

  def unique_users_who_created_programs
    @programs.collect(&:user).compact.uniq
  end

  def program_date_range(program, date_type)
    date_range = program.date_range_for_type(date_type)
    if date_range
      "#{program_date_range_start(date_range)} - #{program_date_range_end(date_range)}"
    else
      "Not yet set"
    end
  end

  def program_date_range_start(date_range)
    date_range && date_range.start_date? ? date_range.start_date.strftime("%m/%d/%Y") : ""
  end

  def program_date_range_end(date_range)
    date_range && date_range.end_date? ? date_range.end_date.strftime("%m/%d/%Y") : ""
  end

  def find_agencies_from_assign_geographies(program)
    agencies = []
    program.geographies.each do |geography|
      agencies += geography.agencies
    end
    agencies.compact.uniq
  end

  def co_op_checkbox(child_geography, obj)
    output = if obj
      check_box_tag("geography_ids[]", child_geography.id, obj.geographies.include?(child_geography), class: "co-op-checkbox", onclick: "addNewGeographies(this)", "data-geography-name" => child_geography.name)
    else
      check_box_tag("geography_ids[]", child_geography.id, false, class: "co-op-checkbox", onclick: "addNewGeographies(this)", "data-geography-name" => child_geography.name)
    end
    output += child_geography.name
    output
  end

  def asset_parameter(asset, parameter="ZONE")
    meta_parameters = asset["metadata"]
    meta_parameter = meta_parameters.find{|m| m if m["name"] == parameter }
    meta_parameter_value = meta_parameter["value"] if meta_parameter
  end

  def date_type_name(date_type)
    if date_type.display_name
      date_type.display_name
    else
      date_type.name.titleize
    end
  end

  def result_label(size)
    label = " result"
    label << 's' if size != 1
    label
  end

  def options_for_calendar_select(geog)
    if geog.national?
      [["National Only", "assigned_geographies"], ["All Calendars", "all_geographies"], ["No Calendars", "no_geographies"]]
    else
      [["Co-Op Only", "assigned_geographies"], ["No Calendars", "no_geographies"]]
    end

  end
end

