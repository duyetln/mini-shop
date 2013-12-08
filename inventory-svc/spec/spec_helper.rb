ENV["RACK_ENV"] = "test"

require "./boot"

module SpecHelpers
  include Rack::Test::Methods

  def app; described_class; end
  def random_string(length=10)
    rand(36**length).to_s(36)
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
  config.color_enabled = true
  config.tty = true

  config.before(:suite) { DatabaseCleaner.strategy = :truncation }  
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }
end

FactoryGirl.find_definitions