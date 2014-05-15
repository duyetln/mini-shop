require 'spec_setup'

Application.load_services!

RSpec.configure do |config|
  config.include SpecHelpers::Services
  config.order = 'default'

  config.before :all do
    DatabaseCleaner.start
  end

  config.after :all do
    DatabaseCleaner.clean
  end
end
