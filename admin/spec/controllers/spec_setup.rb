require 'spec_setup'

RSpec.configure do |config|
  config.include SpecHelpers::Controllers
  config.before :each do
    request.env['HTTP_REFERER'] = 'testhost'
  end
end

require 'spec/controllers/shared/expectations'
