class CalendarsController < ApplicationController

  include SelectableGeographies

  before_filter :selected_geographies, only: [:grid_view, :list_view]

  add_breadcrumb "Calendar", :calendars_path

  # def show
  #   @calendar = current_user.calendars.first_or_create
  # end

  def index
    capture_user_hitting_route
  end

  def grid_view
    year = params[:date][:year].to_i
    month = params[:date][:month].to_i

    capture_user_hitting_route(year: year, month: month)

    if month == 12
      new_month = 1
      new_year = year + 1
    else
      new_month = month + 1
      new_year = year
    end

    @calendar_date_types = DateType.dates_for_calendar

    @start_of_month =  Date.strptime("{ #{year}, #{month}, 1 }", "{ %Y, %m, %d }")
    @end_of_month = Date.strptime("{ #{new_year}, #{new_month}, 1 }", "{ %Y, %m, %d }") - 1

    @programs_for_month = Program.for_given_month(
      start_of_month: @start_of_month, end_of_month: @end_of_month, geography_ids: @selected_geography_ids
    ).preload(
      date_ranges: :date_type
    )


    @moments = Moment.for_given_month(start_of_month: @start_of_month, end_of_month: @end_of_month, geography_ids: @selected_geography_ids)

    @calendar_date_type_ids = DateType.calendar_date_type_ids

    @month_name = Date::MONTHNAMES[month.to_i]
    @year = year

    add_breadcrumb "Month Details", calendars_grid_view_path(date: params[:date])
  end
end
