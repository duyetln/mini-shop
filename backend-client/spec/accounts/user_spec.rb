require 'spec_setup'
require 'spec/base'

describe BackendClient::User do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets addresses correctly' do
      expect(
        model.addresses.map(&:class).uniq
      ).to contain_exactly(BackendClient::Address)
    end

    it 'sets payment_methods correctly' do
      expect(
        model.payment_methods.map(&:class).uniq
      ).to contain_exactly(BackendClient::PaymentMethod)
    end
  end

  describe '.authenticate' do
    let(:email) { rand_str }
    let(:password) { rand_str }

    it 'authenticates with email and password' do
      expect_post('/authenticate', described_class.params(email: email, password: password))
      expect(
        described_class.authenticate(email, password)
      ).to be_instance_of(described_class)
    end
  end

  describe '.confirm' do
    let(:uuid) { rand_str }
    let(:actv_code) { rand_str }

    it 'confirms with uuid and actv code' do
      expect_put("/#{uuid}/confirm/#{actv_code}")
      expect(
        described_class.confirm(uuid, actv_code)
      ).to be_instance_of(described_class)
    end
  end

  shared_examples 'association retreiving' do
    it 'returns association collection' do
      expect_get("/#{model.id}/#{association}", {}, collection(association_payload))
      expect(
        model.send(association).map(&:class).uniq
      ).to contain_exactly(association_class)
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
    context 'params emtpy' do
      it 'does nothing' do
        expect(model.send("create_#{association}".to_sym, {})).to be_nil
      end
    end

    context 'params present' do
      it 'creates association' do
        expect_post(
          "/#{model.id}/#{association.to_s.pluralize}",
          association_class.params(params),
          association_payload
        )
        expect(
          model.send("create_#{association}".to_sym, params)
        ).to be_instance_of(association_class)
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
