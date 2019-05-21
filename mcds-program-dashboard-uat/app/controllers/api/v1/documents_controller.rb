class Api::V1::DocumentsController < ApplicationController
  before_action :expose_schematic
  before_filter :dont_capture_user_behavior

  respond_to :json

  def index
    # respond_with @docs,
    #   location: api_v1_schematic_documents_path,
    #   each_serializer: DocumentSerializer, include_date_ranges: params[:include_date_ranges]zx
    render json: json_indexing
  end

  def json_indexing
    cached = Redis.current.get("#{params['schematic_id']}-schematic-docs")

    if !cached
      cached = generate_json
      Redis.current.setex("#{params['schematic_id']}-schematic-docs", 3600, cached.to_json)
    end

    cached
  end


  def generate_json
    # The preload must be called on documents instead of the schematic, as the docs have a scope called on them.
    @docs = @schematic.documents.order_zone_sort_nulls_last.preload(index_preloads)

    layouts_val = ActiveModel::ArraySerializer.new(
      @docs,
    ).as_json(include_date_ranges: params[:include_date_ranges])

    elements_val = ActiveModel::ArraySerializer.new(
      Element.joins(:documents).where(documents: {id: @docs.map(&:id)}),
      each_serializer: ElementSerializer
    )

    {
      documents: layouts_val,
      elements: elements_val
    }
  end

  private

  def expose_schematic
    @schematic = Schematic.find(params[:schematic_id])
  end

  def index_preloads
    [
      :zone,
      :elements,
      :notes,
      {
        programs: programs_preload_array
      }
    ]
  end

  def programs_preload_array
    result = [:color_blocks, :geographies]

    # only preload date_ranges if needed
    if params[:include_date_ranges]
      result += [date_ranges: :date_type]
    end

    result
  end
end
