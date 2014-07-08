require 'spec_setup'
require 'spec/base'

describe BackendClient::Pricepoint do
  include_examples 'backend client'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets pricepoint_prices correctly' do
      expect(
        model.pricepoint_prices.map(&:class).uniq
      ).to contain_exactly(BackendClient::PricepointPrice)
    end
  end

  describe '.create_pricepoint_price' do
    context 'params emtpy' do
      it 'does nothing' do
        expect(model.create_pricepoint_price({})).to be_nil
      end
    end

    context 'params present' do
      it 'creates pricepoint price' do
        expect_post("/#{model.id}/pricepoint_prices", BackendClient::PricepointPrice.params(params))
        expect do
          expect(
            model.create_pricepoint_price(params)
          ).to be_instance_of(BackendClient::PricepointPrice)
        end.to change { model.attributes }
      end
    end
  end
end
