class SchematicsController < ApplicationController

  before_action :require_user

  def index
    app_params = (params[:app] || '').split('/')
    opts = {
      object_id: app_params.first.try(:to_i),
      app_action: app_params.last

    }

    capture_user_hitting_route(opts)
  end

  def print
    capture_user_hitting_route
    render layout: "print"
  end

end

