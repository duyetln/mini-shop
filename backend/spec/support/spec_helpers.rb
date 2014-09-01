module SpecHelpers
  module Common
    extend ActiveSupport::Concern

    included do
      let(:rand_str) { Faker::Lorem.words.join('') }
      let(:rand_num) { rand(1..50) }
      let(:qty) { rand(1..5) }
      let(:amount) { rand(1..20) }

      let(:user) { FactoryGirl.build :user }
      let(:currency) do
        FactoryGirl.build [
          :usd,
          :eur,
          :gbp
        ].sample
      end
      let(:item) do
        FactoryGirl.build [
          :bundle,
          :physical_item,
          :digital_item
        ].sample
      end
    end

    def parse(json)
      Yajl::Parser.parse(json, symbolize_keys: true)
    end

    def collection(json)
      [parse(json)].to_json
    end

    def activate_inventory!
      PhysicalItem.all.each(&:activate!)
      DigitalItem.all.each(&:activate!)
      Bundle.all.each(&:activate!)
      Batch.all.each(&:activate!)
      Promotion.all.each(&:activate!)
    end
  end
end

module SpecHelpers
  module Models
    extend ActiveSupport::Concern
    include SpecHelpers::Common

    included do
      let(:model_args) { [described_class.to_s.underscore.to_sym] }
      let(:model) { FactoryGirl.build(*model_args) }
      let(:subject) { model }
    end
  end
end

module SpecHelpers
  module Services
    extend ActiveSupport::Concern
    include SpecHelpers::Common
    include Rack::Test::Methods

    included do
      let(:params) { {} }

      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:sort) { [:asc, :desc].sample }
      let(:pagination) { { page: page, size: size, padn: padn, sort: sort } }

      let(:response_status) { last_response.status }
      let(:response_body) { last_response.body }
      let :parsed_response do
        parse(last_response.body)
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
