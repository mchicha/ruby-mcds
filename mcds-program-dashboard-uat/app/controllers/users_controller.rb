class UsersController < ApplicationController
  before_action :require_user
  load_and_authorize_resource

  def index
    if params['search'].present?
      @users = User.where(email: params['search'])
    end
    add_breadcrumb "User Management", users_path

    @users = @users.order(created_at: :desc).page(params[:page])
  end

  def edit
    add_breadcrumb "Edit User", edit_user_path
    @root_geographies = Geography.roots
  end

  def update
    if @user.update(user_params)
      assign_geographies_to_users(params['geography_ids'] || [])
      flash[:success] = 'user updated'
      redirect_to users_path
    else
      flash[:error] = 'user update failed'
      redirect_to edit_user_path(@user)
    end
  end

  def role_stub_set
    raise unless current_user.tukaiz_super_admin?
    Redis.current.set("#{current_user.id}_role_stub", params[:role])

    redirecting_to = Rails.application.routes.recognize_path(URI(request.referer).path)
    redirect_to action: :index, controller: redirecting_to[:controller]
  end


  private

  def assign_geographies_to_users(geography_ids)
    @user.geographies.clear
    geography_ids.each do |geo_id|
      geography = Geography.find(geo_id)
      @user.geographies << geography
    end
  end

  def user_params
    params.require(:user).permit(
      :active, :role
    )
  end

end
