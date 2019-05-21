class PdfWorker
  include Sidekiq::Worker

  sidekiq_options debounce: true, queue: :critical, retry: 1

  def perform(schematic_id)
    @schematic = Schematic.unscoped.find(schematic_id)
    @schematic.render_pdf
  end

end
