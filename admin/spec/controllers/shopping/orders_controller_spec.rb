require 'controllers/spec_setup'

describe Shopping::OrdersController do
  let(:resource_class) { BackendClient::Order }
  let(:resource) { order }

  render_views

  describe '#return' do
    let(:purchase_id) { rand_str }
    let(:method) { :put }
    let(:action) { :return }
    let(:params) { { id: id, purchase_id: purchase_id } }

    before :each do
      expect(BackendClient::Purchase).to receive(:find).with(purchase_id).and_return(purchase)
      expect(purchase).to receive(:return_order).with(id)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
