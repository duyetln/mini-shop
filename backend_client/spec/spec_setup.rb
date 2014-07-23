ENV['APP_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_group 'lib', 'lib/'
end

require './boot'
Dir['spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include SpecHelpers::Common
  config.include SpecHelpers::BackendClient
  config.color = true
  config.tty = true
  config.order = 'random'

  # if config.files_to_run.one?
  #   config.default_formatter = 'doc'
  # end

  config.before :suite do
    BackendClient::ServiceResource.host = 'host'
    BackendClient::ServiceResource.proxy = 'proxy'
  end
end