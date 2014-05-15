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

Application.load_lib!
Application.load_models!
Application.load_config!

module SpecHelpers
  module Common
    extend ActiveSupport::Concern

    included do
      let(:rand_str) { Faker::Lorem.words.join('') }
      let(:rand_num) { rand(1..50) }

      let(:currency) do
        FactoryGirl.build [
          :usd,
          :eur,
          :gbp
        ].sample
      end
      let(:qty) { rand(1..5) }
      let(:amount) { rand(1..20) }
      let(:user) { FactoryGirl.build :user }
      let(:item) do
        FactoryGirl.build [
          :bundle,
          :physical_item,
          :digital_item
        ].sample
      end
    end
  end

  module Services
    extend ActiveSupport::Concern
    include Rack::Test::Methods

    included do
      let(:params) { {} }
      let(:response_status) { last_response.status }
      let(:response_body) { last_response.body }
      let :parsed_response do
        Yajl::Parser.parse(last_response.body, symbolize_keys: true)
      end
    end

    def app
      described_class
    end

    def expect_status(code)
      expect(response_status).to eq(code)
    end

    def expect_response(body)
      expect(response_body).to eq(body)
    end

    def send_request
      send method, path, params
    end
  end
end

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include SpecHelpers::Common
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
end
