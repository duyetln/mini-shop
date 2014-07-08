require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::User do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets addresses correctly' do
      expect(model.addresses).to contain_exactly(
        an_instance_of(BackendClient::Address),
        an_instance_of(BackendClient::Address)
      )
    end

    it 'sets payment_methods correctly' do
      expect(model.payment_methods).to contain_exactly(an_instance_of(BackendClient::PaymentMethod))
    end
  end

  describe '.authenticate' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Lorem.characters(20) }

    it 'authenticates with email and password' do
      expect(described_class.resource).to receive(:[]).with('/authenticate').and_return(doubled_resource)
      expect(doubled_resource).to receive(:post).with(described_class.params(email: email, password: password)).and_return(resource_payload)
      expect(described_class.authenticate(email, password)).to be_an_instance_of(described_class)
    end
  end

  describe '.confirm' do
    let(:uuid) { Faker::Lorem.characters(20) }
    let(:actv_code) { Faker::Lorem.characters(20) }

    it 'confirms with uuid and actv code' do
      expect(described_class.resource).to receive(:[]).with("/#{uuid}/confirm/#{actv_code}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:put).with({}).and_return(resource_payload)
      expect(described_class.confirm(uuid, actv_code)).to be_an_instance_of(described_class)
    end
  end

  shared_examples 'association retreiving' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }

    it 'returns association collection' do
      expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:get).and_return(collection(association_payload))
      expect(model.send(association)).to contain_exactly(an_instance_of(association_class))
    end
  end

  describe '#shipments' do
    let(:association) { :shipments }
    let(:association_class) { BackendClient::Shipment }
    let(:association_payload) { shipment_payload }

    include_examples 'association retreiving'
  end

  describe '#ownerships' do
    let(:association) { :ownerships }
    let(:association_class) { BackendClient::Ownership }
    let(:association_payload) { ownership_payload }

    include_examples 'association retreiving'
  end

  describe '#coupons' do
    let(:association) { :coupons }
    let(:association_class) { BackendClient::Coupon }
    let(:association_payload) { coupon_payload }

    include_examples 'association retreiving'
  end

  describe 'transactions' do
    let(:association) { :transactions }
    let(:association_class) { BackendClient::Transaction }
    let(:association_payload) { transaction_payload }

    include_examples 'association retreiving'
  end

  describe '#orders' do
    let(:association) { :orders }
    let(:association_class) { BackendClient::Order }
    let(:association_payload) { order_payload }

    include_examples 'association retreiving'
  end

  describe '#purchases' do
    let(:association) { :purchases }
    let(:association_class) { BackendClient::Purchase }
    let(:association_payload) { purchase_payload }

    include_examples 'association retreiving'
  end

  shared_examples 'association creation' do
    let(:id) { :id }
    let(:model) { described_class.new id: id }

    context 'params emtpy' do
      it 'does nothing' do
        expect(model.send("create_#{association}".to_sym, {})).to be_nil
      end
    end

    context 'params present' do
      let(:params) { { foo: 'foo', bar: 'bar' } }

      it 'creates association' do
        expect(described_class.resource).to receive(:[]).with("/#{model.id}/#{association.to_s.pluralize}").and_return(doubled_resource)
        expect(doubled_resource).to receive(:post).with(association_class.params(params)).and_return(association_payload)
        expect(model.send("create_#{association}".to_sym, params)).to be_an_instance_of(association_class)
      end
    end
  end

  describe '#create_purchase' do
    let(:association) { :purchase }
    let(:association_class) { BackendClient::Purchase }
    let(:association_payload) { purchase_payload }

    include_examples 'association creation'
  end

  describe '#create_address' do
    let(:association) { :address }
    let(:association_class) { BackendClient::Address }
    let(:association_payload) { address_payload }

    include_examples 'association creation'
  end

  describe '#create_payment_method' do
    let(:association) { :payment_method }
    let(:association_class) { BackendClient::PaymentMethod }
    let(:association_payload) { payment_method_payload }

    include_examples 'association creation'
  end
end
