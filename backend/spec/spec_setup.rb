ENV['RACK_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  add_filter '/db/'
  add_filter '/spec/'
  add_filter '/config/'

  add_group 'models', 'lib/models'
  add_group 'services', 'lib/services'
end

require './boot'
require 'spec/spec_helpers'

Application.load_lib!
Application.load_models!
Application.load_config!

RSpec.configure do |config|
  config.include SpecHelpers::Common
  config.include Mail::Matchers
  config.color_enabled = true
  config.tty = true
  config.order = 'random'

  config.before :suite do
    FactoryGirl.find_definitions
    Mail.defaults do
      delivery_method :test
    end

    begin
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with :truncation
    end
  end
end
