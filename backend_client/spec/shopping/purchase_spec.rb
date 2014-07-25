require 'spec_setup'
require 'spec/base'

describe BackendClient::Purchase do
  include_examples 'backend client'
  include_examples 'default find'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets payment_method correctly' do
      expect(
        model.payment_method
      ).to be_instance_of(BackendClient::PaymentMethod)
    end

    it 'sets billing_address correctly' do
      expect(
        model.billing_address
      ).to be_instance_of(BackendClient::Address)
    end

    it 'sets shipping_address correctly' do
      expect(
        model.shipping_address
      ).to be_instance_of(BackendClient::Address)
    end

    it 'sets payment correctly' do
      expect(
        model.payment
      ).to be_instance_of(BackendClient::Transaction)
    end

    it 'sets orders correctly' do
      expect(
        model.orders.map(&:class).uniq
      ).to contain_exactly(BackendClient::Order)
    end
  end

  describe '#add_or_update_order' do
    context 'params emtpy' do
      it 'does nothing' do
        expect(model.add_or_update_order({})).to be_nil
      end
    end

    context 'params present' do
      it 'creates order' do
        expect_post("/#{model.id}/orders", BackendClient::Order.params(params))
        expect do
          expect(
            model.add_or_update_order(params)
          ).to be_instance_of(BackendClient::Order)
        end.to change { model.attributes }
      end
    end
  end

  describe '#delete_order' do
    let(:order_id) { rand_str }

    it 'deletes order' do
      expect_delete("/#{model.id}/orders/#{order_id}")
      expect do
        expect(
          model.delete_order(order_id)
        ).to eq(model.orders.count)
      end.to change { model.attributes }
    end
  end

  describe '#submit!' do
    it 'submits purchase' do
      expect_put("/#{model.id}/submit")
      expect { model.submit! }.to change { model.attributes }
    end
  end

  describe '#return!' do
    it 'returns purchase' do
      expect_put("/#{model.id}/return")
      expect { model.return! }.to change { model.attributes }
    end
  end

  describe '#return_order' do
    let(:order_id) { instantiated_model.orders.sample.id }

    it 'returns order' do
      expect_put("/#{model.id}/orders/#{order_id}/return")
      expect do
        expect(
          model.return_order(order_id)
        ).to be_instance_of(BackendClient::Order)
      end.to change { model.attributes }
    end
  end
end
