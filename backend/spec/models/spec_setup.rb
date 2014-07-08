require 'spec_setup'

RSpec.configure do |config|
  config.include SpecHelpers::Models

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
