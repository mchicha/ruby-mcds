module ExposeSchematic
  extend ActiveSupport::Concern

  private

    def expose_schematic
      @schematic = Schematic.find_by(id: params[:schematic_id] || params[:id])
    end

end
