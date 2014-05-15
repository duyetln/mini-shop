require 'spec_setup'

Application.load_services!

RSpec.configure do |config|
  config.include SpecHelpers::Services

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
