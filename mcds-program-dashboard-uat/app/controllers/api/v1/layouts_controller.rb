class Api::V1::LayoutsController < ApplicationController
  respond_to :json

  def index
    @layouts = ::Document.preload(document_preloads).where(type_of: 1)

    render json: json_indexing
  end


  def json_indexing
    cached = Redis.current.get("schematic-layouts")

    if !cached
      cached = generate_json
      Redis.current.setex("schematic-layouts", 7200, cached.to_json)
    end

    cached
  end

  def generate_json
    layouts_val = ActiveModel::ArraySerializer.new(
      @layouts,
      each_serializer: DocumentSerializer
    )

    elements_val = ActiveModel::ArraySerializer.new(
      Element.joins(:documents).where(documents: {id: @layouts.map(&:id)}),
      each_serializer: ElementSerializer
    )

    {
      layouts: layouts_val,
      elements: elements_val
    }
  end

  def show
    # Not sure if this is called
    @layouts = ::Document.preload(document_preloads).where(type_of: 3)

    render json: json_indexing
  end

  def create
    @schematic  = Schematic.find(params[:schematic_id])
    @layout     = @schematic.documents.find_by(origin_id: params[:layout_id], document_schematics: {schematic_id: @schematic.id})

    unless @layout
      @document = ::Document.find(params[:layout_id])
      @layout   = @schematic.build_document(@document)
    end

    serialized_elements = ActiveModel::ArraySerializer.new(
      @layout.elements,
      each_serializer: ElementSerializer
    )

    doc_serializer = DocumentSerializer.new(@layout)

    Redis.current.del("#{@schematic.id}-schematic-docs")

    render json: doc_serializer.as_json.merge({elements: serialized_elements})

  end

  private

  def document_preloads
    [
      :zone,
      :elements,
      :notes,
      {
        programs: [:color_blocks, :geographies]
      }
    ]
  end
end
