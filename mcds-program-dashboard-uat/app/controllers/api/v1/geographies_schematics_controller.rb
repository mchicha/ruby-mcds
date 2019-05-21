class Api::V1::GeographiesSchematicsController < ApplicationController
  respond_to :json

  def index
    @schematic = Schematic.find(params[:schematic_id])
    @co_ops = @schematic.geographies.at_depth(2)

    render json: @co_ops, each_serializer: CoopSerializer
  end

  def show
  end

end
