class Api::V1::PdfsController < Api::V1::BaseController
  include ExposeSchematic

  before_action :expose_schematic

  respond_to :json

  def index
    @pdfs = @schematic.images.order(id: :desc)

    respond_with @pdfs
  end
end
