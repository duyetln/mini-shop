ENV["RACK_ENV"] = "test"

require "./boot"

module SpecHelpers
  extend ActiveSupport::Concern
  include Rack::Test::Methods

  def app; described_class; end

  included do
    let(:random_string) { |length=10| rand(36**length).to_s(36) }
    let(:created_customer) { FactoryGirl.create :customer }
    let(:built_customer)   { FactoryGirl.build :customer }
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
  config.color_enabled = true
  config.tty = true
  config.order = "random"

  config.before(:suite) { DatabaseCleaner.strategy = :truncation }  
  config.before(:each)  { DatabaseCleaner.start }
  config.after(:each)   { DatabaseCleaner.clean }
end

FactoryGirl.find_definitions