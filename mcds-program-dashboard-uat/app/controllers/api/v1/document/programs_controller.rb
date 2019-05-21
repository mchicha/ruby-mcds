class Api::V1::Document::ProgramsController < ApplicationController

  respond_to :json

  def index
    @document = Document.find(params[:document_id])
    @programs = @document.programs

    respond_with @programs,
      location: api_v1_schematic_document_programs_path,
      each_serializer: ProgramSerializer
  end

end
