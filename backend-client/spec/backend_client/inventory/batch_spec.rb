require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::Batch do
  include_examples 'backend client'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '#coupons' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }
    let(:association) { :coupons }
    let(:association_class) { BackendClient::Coupon }
    let(:association_payload) { coupon_payload }

    it 'returns association collection' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:get).and_return(collection(association_payload))
      expect(model.send(association)).to contain_exactly(an_instance_of(association_class))
    end
  end

  describe '.create_coupons' do
    let(:qty) { 10 }
    let(:id) { :id }
    let(:model) { described_class.new id: id }

    it 'creates coupons' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/coupons/generate").and_return(doubled_resource)
      expect(doubled_resource).to receive(:post).with(qty: qty).and_return(resource_payload)
      expect { model.create_coupons(qty) }.to change { model.attributes }
    end
  end
end
