module ApplicationHelper

  def current_users_geographies
    # always use national as an option
    national_geo = Geography.find_by(name: "National")
    selectable_geographies = current_user.geographies + [national_geo]
  end

  def navbar_geographies_options
    return {} unless current_user.present?

    grouped_options_for_select(user_geographies, current_user.selected_geography_id)
  end

  def user_geographies
    {
      'Co-Ops Assigned To My Profile (Editable)' => sort_by_name_not_number_in_dropdown(current_user.geographies.pluck(:name, :id)), #grab user assigned geographies
      'All Co-Ops (Read Only)' => [[Geography.national.name, Geography.national.id]] + sort_by_name_not_number_in_dropdown(Geography.co_ops.where.not(id: current_user.geographies.pluck(:id)).pluck(:name, :id)) #grab national then all coops not assigned to user
    }
  end

  def flash_class(name)
    case name
    when "notice"
      "bg-warning"
    when "error"
      "bg-danger"
    else
      "bg-#{name.to_s}"
    end
  end

  def sort_by_name_not_number_in_dropdown(formatted_array)
    formatted_array.sort_by{|name, id| name.match(/(\d+\s-\s)(\D+)/).try(:[], 2)}
  end


  def ellipsify_string(string, length)
    shorten_string(string, length, '...')
  end

  def shorten_string(string, length, end_symbol = nil)
    if string.length > length
      "#{string[0..length]}#{end_symbol}"
    else
      string
    end
  end

end
