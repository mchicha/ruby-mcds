class Api::V1::ElementsController < ApplicationController
  include ExposeSchematic

  before_action :expose_schematic

  respond_to :json

  def index
    # does not work but not currently used
    respond_with @schematic.elements,
      location: api_v1_schematic_element_path,
      each_serializer: Api::V1::ElementSerializer
  end

  def show
    # does not work but not currently used
    @element = @schematic.elements.where(id: params[:id]).first
    respond_with @element,
      location: api_v1_schematic_element_path,
      serializer: Api::V1::ElementSerializer
  end

  def update
    element = @schematic.elements.find_by(id: params[:id])
    @form = Forms::Element::Update.new(element)

    @form.save if @form.validate(element_params)
    @form.last_modified_by(current_user)

    @element = @form.model

    @schematic.touch

    Redis.current.del("#{@schematic.id}-schematic-docs")

    render json: @element,
      location: api_v1_schematic_element_path,
      serializer: ElementSerializer
  end

  private

  def element_params
    params.require(:element).permit(
      :name,
      :id,
      :editable,
      :zindex,
      :layout_id,
      :primary_dam_asset_id,
      :primary_dam_asset_path,
      :secondary_dam_asset_id,
      :secondary_dam_asset_path,
      :primary_program_id,
      :grayscale,
      :secondary_program_id
    ).merge({values: values_params})
  end

  def values_params
    params.require(:element).require(:values).permit!
  end
end
