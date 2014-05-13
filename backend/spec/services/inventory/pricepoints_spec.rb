require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Pricepoints do
  describe 'get /pricepoints' do
    let(:method) { :get }
    let(:path) { '/pricepoints' }

    before :each do
      FactoryGirl.create :pricepoint
    end

    it 'returns all pricepoints' do
      send_request
      expect_status(200)
      expect_response(Pricepoint.all.map do |pricepoint|
        PricepointSerializer.new(pricepoint)
      end.to_json)
    end
  end

  describe 'post /pricepoints' do
    let(:method) { :post }
    let(:path) { '/pricepoints' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'
    end

    context 'valid parameters' do
      let(:params) { { pricepoint: FactoryGirl.build(:pricepoint).attributes } }

      it 'creates new pricepoint' do
        expect { send_request }.to change { Pricepoint.count }.by(1)
        expect_status(200)
        expect_response(PricepointSerializer.new(Pricepoint.last).to_json)
      end
    end
  end

  describe 'put /pricepoints/:id' do
    let(:method) { :put }
    let(:path) { "/pricepoints/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:pricepoint) { FactoryGirl.create :pricepoint }
      let(:id) { pricepoint.id }

      context 'invalid parameters' do
        let(:params) { { pricepoint: { name: nil } } }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let(:params) { { pricepoint: pricepoint.attributes } }

        it 'updates the existing pricepoint' do
          send_request
          expect_status(200)
          expect_response(PricepointSerializer.new(pricepoint).to_json)
        end
      end
    end
  end

  describe 'post /pricepoints/:id/pricepoint_prices' do
    let(:method) { :post }
    let(:path) { "/pricepoints/#{id}/pricepoint_prices" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:pricepoint) { FactoryGirl.create :pricepoint }
      let(:id) { pricepoint.id }

      context 'invalid parameters' do
        let(:params) { { pricepiont_price: { amount: nil } } }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let :params do
          {
            pricepoint_price: FactoryGirl.build(:pricepoint_price).attributes
          }
        end

        it 'creates new pricepoint price' do
          expect { send_request }.to change { pricepoint.pricepoint_prices.count }.by(1)
          expect_status(200)
          expect_response(PricepointSerializer.new(pricepoint).to_json)
        end
      end
    end
  end

  describe 'put /pricepoints/:id/pricepoint_prices/:pricepoint_price_id' do
    let(:method) { :put }
    let(:path) { "/pricepoints/#{id}/pricepoint_prices/#{pricepoint_price_id}" }
    let(:pricepoint_price_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      let(:pricepoint) { FactoryGirl.create :pricepoint }
      let(:id) { pricepoint.id }

      context 'invalid pricepoint price id' do
        let(:pricepoint_price_id) { rand_str }

        include_examples 'not found'
      end

      context 'valid pricepoint price id' do
        let(:pricepoint_price) { FactoryGirl.create :pricepoint_price, pricepoint: pricepoint }
        let(:pricepoint_price_id) { pricepoint_price.id }

        context 'invalid parameters' do
          let(:params) { { pricepoint_price: { amount: nil } } }

          include_examples 'bad request'
        end

        context 'valid parameters' do
          let(:params) { { pricepoint_price: pricepoint_price.attributes } }

          it 'updates the existing pricepoint price' do
            send_request
            expect_status(200)
            expect_response(PricepointSerializer.new(pricepoint).to_json)
          end
        end
      end
    end
  end
end
