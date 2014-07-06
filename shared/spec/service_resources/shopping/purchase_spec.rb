require 'spec_setup'
require 'spec/models/service_resource'

describe Purchase do
  include_examples 'service resource'
  include_examples 'default find'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets payment_method correctly' do
      expect(model.payment_method).to be_an_instance_of(PaymentMethod)
    end

    it 'sets billing_address correctly' do
      expect(model.billing_address).to be_an_instance_of(Address)
    end

    it 'sets shipping_address correctly' do
      expect(model.shipping_address).to be_an_instance_of(Address)
    end

    it 'sets payment correctly' do
      expect(model.payment).to be_an_instance_of(Transaction)
    end

    it 'sets orders correctly' do
      expect(model.orders).to contain_exactly(
        an_instance_of(Order)
      )
    end
  end

  describe '#create_order' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:association) { :order }
    let(:association_class) { Order }

    context 'params emtpy' do
      it 'does nothing' do
        expect(model.create_order({})).to be_nil
      end
    end

    context 'params present' do
      let(:params) { { foo: 'foo', bar: 'bar' } }

      it 'creates order' do
        expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association.to_s.pluralize}").and_return(doubled_resource)
        expect(doubled_resource).to receive(:post).with(association_class.params(params)).and_return(resource_payload)
        expect do
          expect(model.create_order(params)).to be_an_instance_of(association_class)
        end.to change { model.attributes }
      end
    end
  end

  describe '#delete_order' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:order_id) { :order_id }

    it 'deletes order' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/orders/#{order_id}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:delete).and_return(resource_payload)
      expect do
        expect(model.delete_order(order_id)).to be_an_instance_of(Fixnum)
      end.to change { model.attributes }
    end
  end

  describe '#submit!' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }

    it 'submits purchase' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/submit").and_return(doubled_resource)
      expect(doubled_resource).to receive(:put).with({}).and_return(resource_payload)
      expect { model.submit! }.to change { model.attributes }
    end
  end

  describe '#return!' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }

    it 'returns purchase' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/return").and_return(doubled_resource)
      expect(doubled_resource).to receive(:put).with({}).and_return(resource_payload)
      expect { model.return! }.to change { model.attributes }
    end
  end

  describe '#return_order' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:order_id) { 5 }

    it 'returns order' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/orders/#{order_id}/return").and_return(doubled_resource)
      expect(doubled_resource).to receive(:put).with({}).and_return(resource_payload)
      expect do
        expect(model.return_order(order_id)).to be_an_instance_of(Order)
      end.to change { model.attributes }
    end
  end
end
