require 'spec_setup'

describe BackendClient::User do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '#initialize' do
    it 'sets addresses correctly' do
      expect(
        full_model.addresses.map(&:class).uniq
      ).to contain_exactly(BackendClient::Address)
    end

    it 'sets payment_methods correctly' do
      expect(
        full_model.payment_methods.map(&:class).uniq
      ).to contain_exactly(BackendClient::PaymentMethod)
    end

    it 'sets birthdate correctly' do
      expect(
        full_model.birthdate
      ).to be_instance_of(DateTime)
    end
  end

  describe '.authenticate' do
    let(:email) { rand_str }
    let(:password) { rand_str }

    it 'authenticates with email and password' do
      expect_http_action(:post, { path: '/authenticate', payload: described_class.params(email: email, password: password) })
      expect(
        described_class.authenticate(email, password)
      ).to be_instance_of(described_class)
    end
  end

  describe '.confirm' do
    let(:uuid) { rand_str }
    let(:actv_code) { rand_str }

    it 'confirms with uuid and actv code' do
      expect_http_action(:put, { path: "/#{uuid}/confirm/#{actv_code}" })
      expect(
        described_class.confirm(uuid, actv_code)
      ).to be_instance_of(described_class)
    end
  end

  shared_examples 'association retreiving' do
    context 'not paginated' do
      it 'returns association collection' do
        expect_http_action(:get, { path: "/#{bare_model.id}/#{association}", payload: {} }, [parse(association_payload)])
        expect(
          bare_model.send(association).map(&:class).uniq
        ).to contain_exactly(association_class)
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:sort) { :asc }
      let(:params) { { page: page, size: size, padn: padn, sort: sort } }

      it 'returns association collection' do
        expect_http_action(:get, { path: "/#{bare_model.id}/#{association}", payload: params }, [parse(association_payload)])
        expect(
          bare_model.send(association, params).map(&:class).uniq
        ).to contain_exactly(association_class)
      end
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
    let(:association_class) { BackendClient::PaymentTransaction }
    let(:association_payload) { payment_transaction_payload }

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
        expect(bare_model.send("create_#{association}".to_sym, {})).to be_nil
      end
    end

    context 'params present' do
      it 'creates association' do
        expect_http_action(
          :post,
          {
            path: "/#{bare_model.id}/#{association.to_s.pluralize}",
            payload: association_class.params(params)
          },
          parse(result_payload)
        )
        change_expectation = expect do
          expect(
            bare_model.send("create_#{association}".to_sym, params)
          ).to be_instance_of(result_class)
        end

        if changed
          change_expectation.to change { bare_model.send(:attributes) }
        else
          change_expectation.to_not change { bare_model.send(:attributes) }
        end
      end
    end
  end

  describe '#create_purchase' do
    let(:association) { :purchase }
    let(:association_class) { BackendClient::Purchase }
    let(:result_payload) { purchase_payload }
    let(:result_class) { association_class }
    let(:changed) { false }

    include_examples 'association creation'
  end

  describe '#create_address' do
    let(:association) { :address }
    let(:association_class) { BackendClient::Address }
    let(:result_payload) { user_payload }
    let(:result_class) { described_class }
    let(:changed) { true }

    include_examples 'association creation'
  end

  describe '#create_payment_method' do
    let(:association) { :payment_method }
    let(:association_class) { BackendClient::PaymentMethod }
    let(:result_payload) { user_payload }
    let(:result_class) { described_class }
    let(:changed) { true }

    include_examples 'association creation'
  end
end
