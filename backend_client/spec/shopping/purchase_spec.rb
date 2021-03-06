require 'spec_setup'

describe BackendClient::Purchase do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default find'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets payment_method correctly' do
      expect(
        full_model.payment_method
      ).to be_instance_of(BackendClient::PaymentMethod)
    end

    it 'sets shipping_address correctly' do
      expect(
        full_model.shipping_address
      ).to be_instance_of(BackendClient::Address)
    end

    it 'sets payment correctly' do
      expect(
        full_model.payment_transaction
      ).to be_instance_of(BackendClient::PaymentTransaction)
    end

    it 'sets orders correctly' do
      expect(
        full_model.orders.map(&:class).uniq
      ).to contain_exactly(BackendClient::Order)
    end

    it 'sets currency correctly' do
      expect(
        full_model.currency
      ).to be_instance_of(BackendClient::Currency)
    end

    it 'sets amount correctly' do
      expect(
        full_model.amount
      ).to be_instance_of(BigDecimal)
    end

    it 'sets tax correctly' do
      expect(
        full_model.tax
      ).to be_instance_of(BigDecimal)
    end

    it 'sets total correctly' do
      expect(
        full_model.total
      ).to be_instance_of(BigDecimal)
    end

    it 'sets committed_at correctly' do
      expect(
        full_model.committed_at
      ).to be_instance_of(DateTime)
    end
  end

  describe '#user' do
    let(:user) { BackendClient::User.instantiate parse(user_payload) }

    before :each do
      bare_model.user_id = rand_str
    end

    it 'returns user' do
      expect(BackendClient::User).to receive(:find).with(bare_model.user_id).and_return(user)
      expect(bare_model.user).to eq(user)
    end
  end

  describe '#add_or_update_order' do
    context 'params emtpy' do
      it 'does nothing' do
        expect(bare_model.add_or_update_order({})).to be_nil
      end
    end

    context 'params present' do
      it 'creates order' do
        expect_http_action(:post, { path: "/#{bare_model.id}/orders", payload: BackendClient::Order.params(params) })
        expect do
          expect(
            bare_model.add_or_update_order(params)
          ).to be_instance_of(BackendClient::Order)
        end.to change { bare_model.send(:attributes) }
      end
    end
  end

  describe '#delete_order' do
    let(:order_id) { rand_str }

    it 'deletes order' do
      expect_http_action(:delete, { path: "/#{bare_model.id}/orders/#{order_id}" })
      expect do
        expect(
          bare_model.delete_order(order_id)
        ).to eq(bare_model.orders.count)
      end.to change { bare_model.send(:attributes) }
    end
  end

  describe '#submit!' do
    it 'submits purchase' do
      expect_http_action(:put, { path: "/#{bare_model.id}/submit" })
      expect { bare_model.submit! }.to change { bare_model.send(:attributes) }
    end
  end

  describe '#return!' do
    it 'returns purchase' do
      expect_http_action(:put, { path: "/#{bare_model.id}/return" })
      expect { bare_model.return! }.to change { bare_model.send(:attributes) }
    end
  end

  describe '#return_order' do
    let(:order_id) { full_model.orders.sample.id }

    it 'returns order' do
      expect_http_action(:put, { path: "/#{bare_model.id}/orders/#{order_id}/return" })
      expect do
        expect(
          bare_model.return_order(order_id)
        ).to be_instance_of(BackendClient::Order)
      end.to change { bare_model.send(:attributes) }
    end
  end
end
