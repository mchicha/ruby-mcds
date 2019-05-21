Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'schematic' } if Rails.env.development?
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'schematic' } if Rails.env.development?

  config.client_middleware do |chain|
    chain.add Sidekiq::Debounce
  end
end
