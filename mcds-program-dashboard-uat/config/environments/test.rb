Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_files  = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.after_initialize do
    CarrierWave.configure do |config|

      config.permissions = 0666
      config.directory_permissions = 0777
      config.storage = :file
      config.enable_processing = false

      # make sure our uploader is auto-loaded
      ResourceUploader

      # use different dirs when testing
      CarrierWave::Uploader::Base.descendants.each do |klass|
        next if klass.anonymous?
        klass.class_eval do
          def cache_dir
            "#{Rails.root}/spec/support/uploads/tmp"
          end

          def store_dir
            "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
          end
        end
      end
    end
  end

  TkmlAuth.configure do |config|
    config.base_url = "http://localhost:3002"
    config.site_token = "06545a95-88a6-4f65-99a0-2c78325b3004"
    config.site_name = "McDonald's Program Dashboard"
    config.remote_column = "cas_user_id"
    config.username_column = "email"
    config.user_model = User
    config.login_path = "/auth/sign_in"
    config.email_from = "admin@mcds-dashboard.com"
    config.password_reset_destination = "http://localhost:3008/auth/password/reset"
    config.redeem_invite_path = "http://localhost:3008/auth/invitation/accept"
    config.basic_auth_user = "ABC"
    config.basic_auth_pass = "123"
  end


end
