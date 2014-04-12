require 'spec_setup'

module SpecHelpers
  module Services
    extend ActiveSupport::Concern
    include Rack::Test::Methods

    included do
      let(:items) { item_class.kept }
      let(:namespace) { described_class.to_s.tableize }
      let(:parsed_response) { Yajl::Parser.parse(last_response.body, symbolize_keys: true) }
    end

    def app
      described_class
    end

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
  config.include SpecHelpers::Services
end