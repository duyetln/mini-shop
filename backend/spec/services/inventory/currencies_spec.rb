require 'services/spec_setup'

describe Services::Inventory::Currencies do
  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      Currency.where(code: 'USD', sign: '&#36;').first_or_create!
    end

    context 'pagination' do
      let(:scope) { Currency }
      let(:serializer) { CurrencySerializer }

      include_examples 'pagination'
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

    context 'invalid parameters' do
      let(:params) { { currency: { code: nil } } }

      include_examples 'bad request'

      it 'does not create a new currency' do
        expect { send_request }.to_not change { Currency.count }
      end
    end

    context 'valid parameters' do
      let(:params) { { currency: { code: 'USD', sign: '&#36;' } } }

      it 'creates new currency' do
        expect { send_request }.to change { Currency.count }.by(1)
        expect_status(200)
        expect_response(CurrencySerializer.new(Currency.last).to_json)
      end
    end
  end
end
