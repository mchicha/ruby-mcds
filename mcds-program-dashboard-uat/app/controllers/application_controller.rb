class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include TkmlAuth::Authorize
  include Captureable

  before_action :load_token
  before_filter :set_selected_co_op_name

  add_breadcrumb "Home", :root_path

  def selected_geographies
    if current_user.try(:selected_geography_id)
      @selected_geography_ids = [current_user.selected_geography_id]
    else
      @selected_geography_ids = [Geography.national.id]
    end
  end

  def set_selected_co_op_name
    if current_user.try(:selected_geography_id)
      @selected_coop = Geography.where(id: current_user.selected_geography_id).first
    else
      # auto-set for new users
      @selected_coop = Geography.national
      if current_user.present?
        national_geog = Geography.national

        # if for some reason national is not found, it returns all geograpgies.
        # If ever happens for whatever reason, to prevent this from bombing we just
        # grab the first geography
        national_geog = national_geog.first unless national_geog.try(:created_at)

        current_user.selected_geography = national_geog

        current_user.save
      end
    end
  end

  def load_token
    # Looks for token in case WKHTMLTOPDF is making the request
    token = request.headers['HTTP_PDF_TOKEN'] || request.headers['PDF_TOKEN']
    # Sets the session to the first Tukaiz Super Admin it can find
    session[:user_id] = User.find_by(role: User.roles[:tukaiz_super_admin]).try(:id) if token && session[:user_id].nil? && token == ENV['WKHTML_ACCESS_TOKEN']
  end

end
