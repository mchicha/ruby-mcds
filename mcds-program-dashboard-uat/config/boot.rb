# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

## This will default the rails server to the specified port
require'rails/commands/server'
module Rails
  class Server
    alias:default_options_alias :default_options
    def default_options
      default_options_alias.merge!(:Port=>3008)
    end
  end
end
