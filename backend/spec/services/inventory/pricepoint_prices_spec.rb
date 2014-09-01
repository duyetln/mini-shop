require 'services/spec_setup'

describe Services::Inventory::PricepointPrices do
  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:pricepoint_price) { FactoryGirl.create :pricepoint_price }
      let(:id) { pricepoint_price.id }

      context 'invalid parameters' do
        let(:params) { { pricepoint_price: { amount: nil } } }

        include_examples 'bad request'

        it 'does not update the pricepoint price' do
          expect { send_request }.to_not change { pricepoint_price.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { pricepoint_price: { amount: amount } } }

        it 'updates the existing pricepoint price' do
          expect { send_request }.to change { pricepoint_price.reload.attributes }
          expect_status(200)
          expect_response(PricepointPriceSerializer.new(pricepoint_price).to_json)
        end
      end
    end
  end
end
