ENV['RACK_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  add_filter '/db/'
  add_filter '/spec/'
  add_filter '/config/'

  add_group 'models', 'lib/models'
  add_group 'services', 'lib/services'
end

require './boot'

module SpecHelpers
  extend ActiveSupport::Concern
  include Rack::Test::Methods

  def app
    described_class
  end

  included do
    # misc helpers
    let(:random_string) { |length = 10| Faker::Lorem.characters(length) }

    # unit test helpers
    let(:model_args) { [described_class.to_s.underscore.to_sym] }
    let(:model) { FactoryGirl.build(*model_args) }

    # service test helpers
    let(:items) { item_class.kept }
    let(:namespace) { described_class.to_s.tableize }
    let(:parsed_response) { Yajl::Parser.parse(last_response.body, symbolize_keys: true) }

    # common helpers
    let(:user) { FactoryGirl.build :user }
    let(:item) { FactoryGirl.build [:bundle_item, :physical_item, :digital_item].sample }
    let(:sf_item) { FactoryGirl.build :storefront_item }
    let(:qty) { rand(1..10) }
    let(:currency) { |curr = :eur| FactoryGirl.build curr }

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
  config.order = 'random'

  config.before :suite do
    begin
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with :truncation
    end
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end

FactoryGirl.find_definitions
