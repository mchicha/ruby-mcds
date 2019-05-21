class MomentsController < ApplicationController
  before_action :require_user
  before_filter :convert_all_date_options_to_time, only: [:create, :update]
  before_filter :get_programs, only: [:new, :edit]
  before_filter :get_schematics, only: [:new, :edit]
  load_and_authorize_resource

  def index
    capture_user_hitting_route
    @moments = @selected_coop.moments.order(remove_date: :desc)
    @moments = @moments.page(params[:page])
    add_breadcrumb "Events", moments_path
  end

  def new
    capture_user_hitting_route
    add_breadcrumb "New Event", new_moment_path
    authorize! :create, GeographyMoment.new(geography: @selected_coop)
  end

  def create
    # The following assigns the current user as the creator.
    # Only Super Users can see on #index. Considering it is super front facing to be on welcome page,
    # this will allow us to track down a user in case a complaint is lodged
    params[:moment][:user_id] = current_user.id

    @moment.update_attributes(moment_params)
    redirect_to moments_path
  end

  def show
    capture_user_hitting_route
    add_breadcrumb "Event Details", moment_path
  end

  def edit
    capture_user_hitting_route
    add_breadcrumb "Edit Event", edit_moment_path
  end

  def update
    @moment.update_attributes(moment_params)
    redirect_to moments_path
  end


  private

  def moment_params
    params[:moment][:geography_ids] = [@selected_coop.id]

    @moment_params ||= params.require(:moment).permit(
      :title, :body, :post_date, :remove_date, :archived, :momentable_id, :momentable_type, :show_all, geography_ids: []
    )
  end

  def convert_all_date_options_to_time
    moment_params["post_date"] = convert_date(moment_params[:post_date]) if moment_params["post_date"]
    moment_params["remove_date"] = convert_date(moment_params[:remove_date]) if moment_params["remove_date"]
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
