class KillswitchesController < ApplicationController
  before_action :require_user
  load_and_authorize_resource

  def index

  end

  def edit

  end

  def update
    @killswitch.update_attributes(killswitch_params)
    redirect_to killswitches_path
  end

  private

  def killswitch_params
    params.require(:killswitch).permit(
      :name, :killed, :description
    )
  end
end
