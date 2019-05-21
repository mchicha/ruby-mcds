class ThumbUrlWorker
  include Sidekiq::Worker

  sidekiq_options debounce: true, retry: 0

  def perform(program_id)
    program = Program.find(program_id)
    dam_assets = Array(program.dam_assets)
    program.update_attributes(thumb_image_url: (dam_assets.first || {})['thumb_url'])
  end
end
