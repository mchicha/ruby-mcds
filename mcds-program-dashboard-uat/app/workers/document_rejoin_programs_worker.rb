class DocumentRejoinProgramsWorker
  include Sidekiq::Worker

  sidekiq_options debounce: true, retry: 0

  def perform
    Document.joins(
      :schematics
    ).where(
      schematics: {id: Schematic.non_archived.pluck(:id)}
    ).preload(
      :schematics, :elements
    ).find_each do |doc|
      doc.rejoin_programs
    end
  end
end
