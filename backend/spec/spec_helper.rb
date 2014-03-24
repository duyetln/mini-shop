ENV["RACK_ENV"] = "test"

require "./boot"

module SpecHelpers
  extend ActiveSupport::Concern
  include Rack::Test::Methods

  def app; described_class; end

  included do
    # misc helpers
    let(:random_string) { |length=10| Faker::Lorem.characters(length) }

    # unit test helpers
    let(:args) { [ described_class.to_s.underscore.to_sym ] }
    let(:saved_model) { FactoryGirl.create(*args) }
    let(:new_model) { FactoryGirl.build(*args) }
    
    # service test helpers
    let(:items) { item_class.kept }
    let(:namespace) { described_class.to_s.tableize }
    let(:parsed_result) { Yajl::Parser.parse(last_response.body, symbolize_keys: true) }

    def expect_status(code)
      expect(last_response.status).to eq(code)
    end

    def expect_empty_response
      expect(last_response.body).to be_empty
    end

    def expect_response(body)
      expect(last_response.body).to eq(body)
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelpers
  config.color_enabled = true
  config.tty = true
  config.order = "random"

  config.before :suite do
    begin
      DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: true }
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each)  { DatabaseCleaner.clean }
end

FactoryGirl.find_definitions