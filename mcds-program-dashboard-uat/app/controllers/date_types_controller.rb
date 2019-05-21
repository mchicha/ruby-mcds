class DateTypesController < ApplicationController
  before_action :require_user
  load_and_authorize_resource

  def index
    @date_types = @date_types
    @date_types = @date_types.order(sort_order: :asc).page(params[:page])
  end

  def edit

  end

  def update
    udpate_params = date_type_params
    udpate_params['display_name'] = nil if udpate_params['display_name'] == ''
    @date_type.update_attributes(udpate_params)
    redirect_to date_types_path
  end

  private

  def date_type_params
    params.require(:date_type).permit(
      :name, :display_name, :required, :end_date_required, :show_on_calendar, :sort_order, :fa_icon, :icon_color,
    )
  end
end
