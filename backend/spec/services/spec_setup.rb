require 'spec_setup'

RSpec.configure do |config|
  config.include SpecHelpers::Services

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end

require 'spec/services/shared/errors'
require 'spec/services/shared/pagination'
