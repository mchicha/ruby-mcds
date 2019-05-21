class GeographiesController < ApplicationController
  respond_to :js
  before_action :require_user

  def add_user
    geography = Geography.find(params[:geography_id])
    user = User.find(params[:user_id])
    if params[:checked] && params[:checked] == "false"
      user.geographies.delete(geography)
    else
      user.geographies << geography
    end
    render nothing: true
  end

  def find_children
    @parent_geography = Geography.find(params[:geography_id])
    @obj = params[:class_name].constantize.find(params[:obj_id]) if params[:class_name] && params[:obj_id]
    @class_name = params[:class_name]
    respond_to do |format|
      format.js
    end
  end

  def set_selected_id
    current_user.selected_geography_id = params[:geography_id]
    current_user.save

    # This requires an index action on the controller, calendar controller does not have one,
    # but is disabled so users cannot access anyway. It is going to be rewritten before the interface is enabled.
    redirecting_to = Rails.application.routes.recognize_path(URI(request.referer).path)
    redirect_to action: :index, controller: redirecting_to[:controller]
  end
end
