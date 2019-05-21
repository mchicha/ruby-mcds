class Api::V1::SchematicsController < ApplicationController
  include PaginationMetadata

  before_filter :coerce_params, :require_user

  DATE_RANGES = %w(release_date end_date updated_at)

  load_and_authorize_resource
  before_filter :selected_geographies, only: [:index]
  before_filter :dont_capture_user_behavior

  respond_to :json

  def index
    @schematics = Schematic.unscoped

    schematic_status
    # You need to do the status filter before pagination. When done first, pagination adds the limits to the subqueries when they are added, which messes all sorts of stuff up
    @schematics = @schematics.
      index_for_selected_geographies(geography_ids: @selected_geography_ids, user: current_user).
      preload(:programs, :agencies, :geographies).
      page(params[:currPage]).
      per(params[:perPage] || 20)

    search
    scope_dates
    order_by
    test_schematics

    render json: @schematics, each_serializer: SchematicSerializer, meta: paginate_meta(@schematics)
  end

  def show
    @schematic = Schematic.find(params[:id])
    respond_with @schematic, serializer: SchematicSerializer
  end

  def create
    @form = Forms::Schematic::Create.new(Schematic.new)
    ## geographies and co-ops are the same thing
    @geographies = Geography.where(id: params[:geography_ids])
    @form.model.geographies << @geographies
    # save and set form object
    @form.save if @form.validate(schematic_params)
    @schematic = @form.model

    respond_with @schematic, location: api_v1_schematics_path
  end

  def edit
    @schematic = Schematic.find(params[:id])
    @geographies = Geography.where(id: params[:geography_ids])

    @schematic.geographies.destroy_all #destroy previously associated co-ops
    @schematic.geographies << @geographies #adds newly & previously selected co-ops

    render json: @schematic
  end

  def update
    @form = Forms::Schematic::Update.new(Schematic.find_by_id(params[:id]))

    @form.save if @form.validate(schematic_params)
    @schematic = @form.model

    respond_with @schematic, location: api_v1_schematic_path(@schematic)
  end

private
    def schematic_params
      params.require(:schematic).permit(
        :id,
        :name,
        :status,
        :sch_type,
        {:geography_ids => []},
        :source_id,
        :parent_id,
        :release_date,
        :end_date,
        :updated_at
      ).merge(last_modified_by_id: current_user.id)
    end

    def coerce_params
      if params.keys.size > 0
        DATE_RANGES.each do |attr|
          if params[attr]
            params[attr]['from']  = Date.parse(params[attr]['from']) if params[attr]['from'].present?
            params[attr]['to']    = Date.parse(params[attr]['to']) if params[attr]['to'].present?
          end
        end
      end
    end

    def schematic_status
      return unless params[:status].is_a?(Array) && !params[:status].empty?

      @schematics = @schematics.by_status(params[:status])
    end

    def scope_dates
      DATE_RANGES.each do |attr|
        if params[attr] && (params[attr]['to'].is_a?(Date) || params[attr]['from'].is_a?(Date))
          @schematics = @schematics.for_date_range(attribute: attr, from: params[attr]['from'], to: params[attr]['to'])
        end
      end
    end

    def test_schematics
      @schematics = @schematics.test if params[:isTest] == '1'
    end

    def order_by
      column    = params[:sort] || 'id'
      direction = params[:dir] && params[:dir] == 'false' ? :asc : :desc

      @schematics = @schematics.reorder(column => direction)
    end

    def search
      if params[:search] && params[:search].length > 0
        @schematics = @schematics.where(
          Schematic.arel_table[:name].matches("%#{params[:search]}%")
        )
      end
    end

end
