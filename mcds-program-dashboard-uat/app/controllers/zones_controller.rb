class ZonesController < ApplicationController
  before_action :require_user
  load_and_authorize_resource

  def index
    @zones = @zones
    @zones = @zones.order(sort_order: :asc).page(params[:page])
  end

  def edit

  end

  def update
    @zone.update_attributes(zone_params)
    redirect_to zones_path
  end

  private

  def zone_params
    params.require(:zone).permit(
      :name, :sort_order
    )
  end
end
