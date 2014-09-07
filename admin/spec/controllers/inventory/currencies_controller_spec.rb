require 'controllers/spec_setup'

describe Inventory::CurrenciesController do
  let(:resource_class) { BackendClient::Currency }
  let(:resource) { currency }

  render_views

  describe '#create' do
    let(:code) { rand_str }
    let(:sign) { rand_str }
    let(:method) { :post }
    let(:action) { :create }
    let(:params) { { currency: { code: code, sign: sign } } }
    let(:create_params) { { code: code, sign: sign } }

    before :each do
      expect_create
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
