module SpecHelpers
  module Common
    extend ActiveSupport::Concern

    included do
      let(:rand_str) { Faker::Lorem.words.join('') }
      let(:rand_num) { rand(1..50) }
      let(:qty) { rand(1..5) }
      let(:amount) { rand(1..20) }
    end

    def parse(json)
      Yajl::Parser.parse(json, symbolize_keys: true)
    end
  end
end

module SpecHelpers
  module BackendClient
    extend ActiveSupport::Concern
    include ::BackendClient::Spec

    included do
      let(:namespace) { described_class.name.demodulize.underscore }
      let(:request) { double(RestClient::Resource) }
      let(:params) { { key1: rand_str, key2: rand_num } }
      let(:headers) { { key3: rand_str, key4: rand_num } }


      let :bare_model do
        model = described_class.new
        model.id = rand_str
        model
      end

      let :full_model do
        send("mocked_#{namespace}".to_sym)
      end

      let(:crude_payload) { send("#{namespace}_payload".to_sym) }
      let(:parsed_payload) { send("parsed_#{namespace}_payload".to_sym) }
    end

    def expect_http_action(action, params = {}, result = parsed_payload)
      expect(described_class).to respond_to(action)
      match_expectation = receive(action)
      match_expectation = match_expectation.with(params) if params.present?
      match_expectation = match_expectation.and_return(result) if result.present?
      expect(described_class).to match_expectation
    end
  end
end
