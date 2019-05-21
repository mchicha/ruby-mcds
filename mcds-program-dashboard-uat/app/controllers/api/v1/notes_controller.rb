class Api::V1::NotesController < Api::V1::BaseController
  include ExposeSchematic

  before_action :expose_schematic, :expose_document
  after_action :touch_schematic

  respond_to :json

  def index
    respond_with @document.try(:notes)
  end

  def create
    @note = @document.notes.create(note_params)

    @document.note_check_on_descendants(@note)

    respond_with @note, location: api_v1_schematic_document_notes_path(@schematic, @document)
  end

  def update
    @note = @document.notes.find(params[:id])
    @note.update(note_params)

    respond_with @note, location: api_v1_schematic_document_notes_path(@schematic, @document)
  end

  def destroy
    @note = @document.notes.find(params[:id])
    @note.remove_from_document

    respond_with @note, location: api_v1_schematic_document_notes_path(@schematic, @document)
  end

  private

    def touch_schematic
      @schematic.try(:touch)
    end

    def note_params
      params.require(:note).permit(
        :name,
        :body,
        :width,
        :height,
        :x,
        :y
        )
    end

    def expose_document
      @document = Document.find_by(id: params[:document_id])
    end
end
