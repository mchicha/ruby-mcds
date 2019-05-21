class BubbleDownWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform(element_id, old_attrs, new_attrs)
    Element.find(element_id).bubble_down_changes(old_attrs, new_attrs) if element_id
  end

end
