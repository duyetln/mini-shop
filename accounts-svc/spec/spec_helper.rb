ENV["RACK_ENV"] = "test"

require "./boot"

module SpecHelpers

  def random_string(length=10)
    rand(36**length).to_s(36)
  end

end

RSpec.configure do |config|
  config.include SpecHelpers
  config.color_enabled = true
  config.tty = true

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end
  
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }
end

FactoryGirl.find_definitions