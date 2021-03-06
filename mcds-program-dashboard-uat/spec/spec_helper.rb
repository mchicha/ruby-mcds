ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
require 'factory_girl_rails'
# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this
# file to always be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.reverse.each {|f| require f}

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.include FactoryGirl::Syntax::Methods
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.after(:each) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end

  config.before(:each) do
    stub_request(:post, "http://ABC:123@localhost:3002/api/v3/users").
      with(:body => "{\"user\":{\"email\":\"blah@blah.com\"}}",
      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:post, "http://ABC:123@localhost:3002/api/v3/users").
      with(:body => "{\"user\":{\"email\":\"blah@blah.com\"}}",
      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:put, "http://ABC:123@localhost:3002/api/v3/users/").
      with(:body => "{\"user\":{\"email\":\"blah@blah.com\"}}",
      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:post, "http://ABC:123@localhost:3002/api/v3/users").
       with(:body => "{\"user\":{\"email\":\"happy@days.com\"}}",
            :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
       to_return(:status => 200, :body => "", :headers => {})

    stub_request(:put, "http://ABC:123@localhost:3002/api/v3/users/").
         with(:body => "{\"user\":{\"email\":\"blah@blah.com\"}}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
         to_return(:status => 200, :body => "", :headers => {})

    stub_request(:post, "http://ABC:123@localhost:3002/api/v3/users").
       with(:body => "{\"user\":{\"email\":\"happy@days.com\"}}",
            :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
       to_return(:status => 200, :body => "", :headers => {})

    stub_request(:post, "http://ABC:123@localhost:3002/api/v3/saml/consume").
      with(:body => "{\"SAMLResponse\":\"12345\",\"format\":\"html\",\"controller\":\"api/v1/users\",\"action\":\"get_claims\"}",
        :headers => {'Content-Type'=>'application/json', 'Referer'=>'test.host', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
      to_return(:status => 201, :body => "", :headers => {})

    stub_request(:post, "http://ABC:123@localhost:3002/api/v3/saml/consume").
      with(:body => "{\"SAMLResponse\":\"bad_request\",\"format\":\"html\",\"controller\":\"api/v1/users\",\"action\":\"get_claims\"}",
        :headers => {'Content-Type'=>'application/json', 'Referer'=>'test.host', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
      to_return(:status => 401, :body => "", :headers => {})

    stub_request(:post, "http://ABC:123@tkml.dev:3002/api/v3/saml/consume").
       with(:body => "{\"SAMLResponse\":\"12345\",\"format\":\"html\",\"controller\":\"api/v1/users\",\"action\":\"get_claims\"}",
            :headers => {'Content-Type'=>'application/json', 'Referer'=>'test.host', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
       to_return(:status => 200, :body => "", :headers => {})

    stub_request(:post, "http://ABC:123@tkml.dev:3002/api/v3/saml/consume").
         with(:body => "{\"SAMLResponse\":\"bad_request\",\"format\":\"html\",\"controller\":\"api/v1/users\",\"action\":\"get_claims\"}",
              :headers => {'Content-Type'=>'application/json', 'Referer'=>'test.host', 'X-Tkml-Auth-Token'=>'06545a95-88a6-4f65-99a0-2c78325b3004'}).
         to_return(:status => 200, :body => "", :headers => {})


    stub_request(:get, "http://digital-asset-manager.dev/api/assets?archived=false&search=").
      with(:headers => {'Authorization'=>'Token a7dd4aae7b6e4ea4bb3ab9924b820417'}).
        to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, "http://digital-asset-manager.dev/api/asset_types/").
         with(:body => "verbose=true",
              :headers => {'Authorization'=>'Token token="a7dd4aae7b6e4ea4bb3ab9924b820417"'}).
         to_return(:status => 200, :body => "", :headers => {})
  end


# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Limits the available syntax to the non-monkey patched syntax that is recommended.
  # For more details, see:
  #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://myronmars.to/n/dev-blog/2014/05/notable-changes-in-rspec-3#new__config_option_to_disable_rspeccore_monkey_patching
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
end
