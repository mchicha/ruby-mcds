class WelcomeController < ApplicationController

  before_action :require_user
  before_action :selected_geographies

  def index
    @schematics = schematics_by_national_or_coop(@selected_coop)

    @alerts = load_alerts(@selected_coop)

    @report = WelcomePageSchematicsReport.new(@schematics)
  end


  def schematics_by_national_or_coop(selected_coop)
    schematics_query = selected_coop.schematics.active_published.group(:id).preload(programs: welcome_program_preload_array, parent: [programs: welcome_program_preload_array])
    schematics_query = schematics_query.where.not(parent_id: nil) unless selected_coop.national?
    schematics_query
  end

  def welcome_program_preload_array
    [:geography_program, :delivery_method, date_ranges: :date_type]
  end

  def load_alerts(selected_coop)
    # limit is currently a stop gap in case for whatever reason hundreds end up on this page
    # pagination is not in scope, but do not want to see what happens if thousands are added.
    Alert.preload(:geographies).for_homepage(selected_coop).limit(40)
  end
end

