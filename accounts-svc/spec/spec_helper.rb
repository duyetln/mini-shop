ENV["RACK_ENV"] = "test"

require "./boot"

module SpecHelpers
  extend ActiveSupport::Concern
  include Rack::Test::Methods

  def app; described_class; end

  included do
    let(:random_string) { |length=10| rand(36**length).to_s(36) }
    let(:created_user) { FactoryGirl.create :user }
    let(:built_user)   { FactoryGirl.build :user }
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