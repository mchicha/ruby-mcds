Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  # instead of sending the emails in development, open it up in browser (letter_opener gem)
  config.action_mailer.delivery_method = :letter_opener

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.sass.debug_info = true
  config.sass.line_comments = false # source maps don't get output if this is true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  TkmlAuth.configure do |config|
    config.base_url = "http://localhost:3002"
    config.site_token = "06545a95-88a6-4f65-99a0-2c78325b3004"
    config.site_name = "McSource Online"
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
