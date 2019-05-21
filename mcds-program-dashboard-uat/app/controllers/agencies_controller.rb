class AgenciesController < ApplicationController

  include SelectableGeographies

  before_action :require_user
  before_filter :find_agency, except: [:index, :create, :autocomplete_user_email]
  before_filter :agencies_geographies, only: [:manage_geographies, :manage_users]
  before_filter :find_selectable_geographies, only: [:manage_geographies, :index]
  autocomplete :user, :email, display_value: :email, full: true
  load_and_authorize_resource

  respond_to :html, :js

  add_breadcrumb "Manage Agencies", :agencies_path

  def index
    capture_user_hitting_route
    @agencies = Agency.all
  end

  def create
    capture_user_hitting_route
    @agency = Agency.new(agency_params)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    capture_user_hitting_route
    respond_to do |format|
      format.js
    end
  end

  # Manage agencies geographies actions
  def manage_geographies
    add_breadcrumb "Geographies", manage_geographies_agency_path(@agency)
  end

  def add_geographies_to_agency
    if !params[:geography_ids].blank?
      selected_geographies = Geography.find(params[:geography_ids])
      selected_geographies.each do |geography|
        @agency.geographies << geography unless @agency.geographies.include?(geography)
      end
      flash[:notice] = "#{selected_geographies.count} co-ops have been added to this agency."
    else
      flash[:error] = "No co-ops were selected."
    end
    redirect_to agencies_path
  end

  def destroy_agency_geography
    @geography = Geography.find(params[:geography_id])
    respond_to do |format|
      format.js
    end
  end

  def destroy_all_geographies_from_agency
    @agency.geographies.clear
    render nothing: true
  end

  # Manage agencies' users actions
  def manage_users
    @agency_users = @agency.users
    @all_users = User.all
    # add_breadcrumb "Users", manage_users_agency_path(@agency)
  end

  def add_user_to_agency
    if params[:agency_user] && !params[:agency_user][:user_id].blank?
      user = User.find(params[:agency_user][:user_id])
      if @agency.users.include?(user)
        flash[:notice] = "#{user.email} is already associated to this agency."
      else
        @agency.users << user
        flash[:success] = "#{user.email} has been added to this agency."
      end
    else
      flash[:error] = "No user was found with that email address."
    end
    redirect_to agencies_path
  end

  def destroy_agency_user
    @user = User.find(params[:user_id])
    @agency.users.delete(@user)
    respond_to do |format|
      format.js
    end
  end

  private

  def agencies_geographies
    # geographies = co-ops (client terminology)
    @agency_geographies = @agency.geographies
  end

  def find_agency
    @agency = Agency.find(params[:id])
  end

  def agency_params
    params.require(:agency).permit(:name)
  end

  def get_autocomplete_items(params)
    # items = super(params)
    search_term = "%#{params[:term]}%"
    user = params[:model].arel_table
    User.where(user[:email].matches(search_term).or(user[:first_name].matches(search_term)).or(user[:last_name].matches(search_term)))
  end


end
