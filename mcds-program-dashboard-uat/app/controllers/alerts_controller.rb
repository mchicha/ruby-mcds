class AlertsController < ApplicationController
  before_action :require_user
  before_filter :convert_all_date_options_to_time, only: [:create, :update]
  before_filter :get_programs, only: [:new, :edit]
  before_filter :get_schematics, only: [:new, :edit]
  load_and_authorize_resource

  def index
    capture_user_hitting_route
    add_breadcrumb "Alerts", alerts_path
    @alerts = @selected_coop.alerts.order(remove_date: :desc)
    @alerts = @alerts.page(params[:page])
  end

  def new
    add_breadcrumb "New Alert", new_alert_path
    authorize! :create, AlertGeography.new(geography: @selected_coop)
  end

  def create
    # The following assigns the current user as the creator.
    # Only Super Users can see on #index. Considering it is super front facing to be on welcome page,
    # this will allow us to track down a user in case a complaint is lodged

    @alert.update_attributes(alert_params)
    redirect_to alerts_path
  end

  def show
    capture_user_hitting_route
    add_breadcrumb "Alert Details", alert_path(@alert)
  end

  def edit
    add_breadcrumb "Edit Alert", edit_alert_path(@alert)
  end

  def update
    @alert.update_attributes(alert_params)
    redirect_to alerts_path
  end


  private

  def alert_params
    params[:alert][:user_id] = current_user.id
    params[:alert][:geography_ids] = [@selected_coop.id]

    @alert_params ||= params.require(:alert).permit(
      :title, :body, :post_date, :user_id, :remove_date, :archived, :alertable_id, :alertable_type, :show_all, geography_ids: []
    )
  end

  def convert_all_date_options_to_time
    alert_params["post_date"] = convert_date(alert_params[:post_date]) if alert_params["post_date"]
    alert_params["remove_date"] = convert_date(alert_params[:remove_date]) if alert_params["remove_date"]
  end

  def convert_date(param)
    Date.strptime(param, '%m/%d/%Y') unless param.blank?
  end

  def get_programs
    @programs = program_query
  end

  def program_query
    Program.for_specific_geographies(@selected_coop).active_status
  end

  def get_schematics
    @schematics = selected_coop_schematics
    @schematics = child_schematics_only unless @selected_coop.national?
    @schematics
  end

  def selected_coop_schematics
    @selected_coop.schematics.non_archived.group(:id)
  end

  def child_schematics_only
    @schematics.where.not(parent_id: nil)
  end

end
