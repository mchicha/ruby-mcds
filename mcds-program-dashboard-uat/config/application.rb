require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module McdsProgramDasboard
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.use Rack::Cors do
      allow do
        origins(
          /localhost\:\d{3,}/,
          /[\w\-.]*tkmltechnology.com/,
          /[\w\-.]*dev/,
          /[\w\-.]*pixalized.com/)
        resource '*', :headers => :any,
          :methods => [:get, :post, :put, :patch, :options, :delete]
      end
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += %W(#{config.root}/lib)
    config.action_mailer.default_url_options = { :host => ENV["HOST"] }

    # Prevent warning message in carrierwave
    config.active_record.raise_in_transactional_callbacks = true
    ## AWS S3
    config.after_initialize do

      if ENV["S3_BUCKET_NAME"]
        CarrierWave.configure do |config|
          config.storage :fog
          config.permissions = 0666
          config.directory_permissions = 0777
          config.fog_credentials = {
            provider:               "AWS",
            aws_access_key_id:      ENV['S3_ACCESS_KEY_ID'],
            aws_secret_access_key:  ENV['S3_SECRET_ACCESS_KEY'],
            region:                 ENV['S3_REGION']
          }
          config.fog_directory =    ENV['S3_BUCKET_NAME']
          config.fog_public = false
        end
      end

    end
  end
end
