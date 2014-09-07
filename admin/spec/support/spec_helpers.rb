module SpecHelpers
  extend ActiveSupport::Concern

  module Common
    extend ActiveSupport::Concern
    include BackendClient::Spec

    included do
      let(:rand_str) { Faker::Lorem.words.join('') }
      let(:rand_num) { rand(1..50) }
      let(:qty) { rand(1..5) }
      let(:amount) { rand(1..20) }

      [
        :user,
        :currency,
        :pricepoint_price,
        :pricepoint,
        :discount,
        :price,
        :physical_item,
        :digital_item,
        :bundle,
        :bundled,
        :store_item,
        :promotion,
        :batch,
        :coupon,
        :address,
        :payment_method,
        :transaction,
        :order,
        :purchase,
        :ownership,
        :shipment,
        :status
      ].each do |model|
        let model do
          send("mocked_#{model}".to_sym)
        end
      end
    end

    def parse(json)
      Yajl::Parser.parse(json, symbolize_keys: true)
    end
  end

  module Controllers
    extend ActiveSupport::Concern
    include SpecHelpers::Common

    included do
      let(:params) { {} }
      let(:create_params) { {} }

      let(:id) { rand_str }
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:sort) { [:asc, :desc].sample }
      let(:pagination) { { page: page, size: size, padn: padn, sort: sort } }

      let(:response_status) { response.status }
      let(:response_body) { response.body }
    end

    def expect_all(klass = resource_class, record = resource)
      expect(klass).to receive(:all).and_return([record])
    end

    def expect_find(klass = resource_class, record = resource)
      expect(resource_class).to receive(:find).with(id).and_return(resource)
    end

    def expect_create(klass = resource_class, record = resource, values = create_params)
      expect(resource_class).to receive(:create).with(values).and_return(record)
    end

    def expect_update(record = resource, keys = update_keys)
      expect(record).to receive(:update!).with(*keys)
    end

    def expect_status(code)
      expect(response_status).to eq(code)
    end

    def expect_response(body)
      expect(response_body).to eq(body)
    end

    def send_request
      send method, action, params
    end
  end

  include Common
  include Controllers
end
