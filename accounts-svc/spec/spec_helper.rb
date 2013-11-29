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
end

FactoryGirl.find_definitions