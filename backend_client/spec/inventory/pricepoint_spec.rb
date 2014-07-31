require 'spec_setup'

describe BackendClient::Pricepoint do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets pricepoint_prices correctly' do
      expect(
        full_model.pricepoint_prices.map(&:class).uniq
      ).to contain_exactly(BackendClient::PricepointPrice)
    end
  end

  describe '.create_pricepoint_price' do
    context 'params emtpy' do
      it 'does nothing' do
        expect(bare_model.create_pricepoint_price({})).to be_nil
      end
    end

    context 'params present' do
      it 'creates pricepoint price' do
        expect_http_action(:post, { path: "/#{bare_model.id}/pricepoint_prices", payload: BackendClient::PricepointPrice.params(params) })
        expect do
          expect(
            bare_model.create_pricepoint_price(params)
          ).to be_instance_of(BackendClient::PricepointPrice)
        end.to change { bare_model.send(:attributes) }
      end
    end
  end
end
