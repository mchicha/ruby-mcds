# Be sure to restart your server when you modify this file.
Rails.application.assets.register_engine('.slim', Slim::Template)

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.

Rails.application.config.assets.precompile += %w( programs.js programs.css ckeditor/* schematics.js geographies.js message_drawer.js vendor.js calendars.js calendars.css welcome.js print.js prints.css alerts.js calendar_grid_view.js)

