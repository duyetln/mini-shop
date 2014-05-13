require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Prices do
  describe 'get /prices' do
    let(:method) { :get }
    let(:path) { '/prices' }

    before :each do
      FactoryGirl.create :price
    end

    it 'returns all prices' do
      send_request
      expect_status(200)
      expect_response(Price.all.map do |price|
        PriceSerializer.new(price)
      end.to_json)
    end
  end

  describe 'post /prices' do
    let(:method) { :post }
    let(:path) { '/prices' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'
    end

    context 'valid parameters' do
      let :params do
        {
          price: FactoryGirl.build(
            :price,
            pricepoint: FactoryGirl.create(:pricepoint)
          ).attributes
        }
      end

      it 'creates new price' do
        expect { send_request }.to change { Price.count }.by(1)
        expect_status(200)
        expect_response(PriceSerializer.new(Price.last).to_json)
      end
    end
  end

  describe 'put /prices/:id' do
    let(:method) { :put }
    let(:path) { "/prices/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:price) { FactoryGirl.create :price }
      let(:id) { price.id }

      context 'invalid parameters' do
        let(:params) { { price: { pricepoint_id: nil } } }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let(:params) { { price: price.attributes } }

        it 'updates the existing price' do
          send_request
          expect_status(200)
          expect_response(PriceSerializer.new(price).to_json)
        end
      end
    end
  end
end