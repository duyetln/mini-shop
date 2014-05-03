require 'spec_setup'

module SpecHelpers
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

Application.load_services!

RSpec.configure do |config|
  config.include SpecHelpers::Services
end
