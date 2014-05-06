require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Shopping::PaymentMethods do
  let :user do
    User.find FactoryGirl.create(:user).id
  end
  let(:id) { user.id }

  describe 'get /users/:id/payment_methods' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/payment_methods" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the payment methods' do
        send_request
        expect_status(200)
        expect_response(user.payment_methods.map do |payment_method|
          PaymentMethodSerializer.new(payment_method)
        end.to_json)
      end
    end
  end

  describe 'post /users/:id/payment_methods' do
    let(:method) { :post }
    let(:path) { "/users/#{id}/payment_methods" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { {} }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let :params do
          { payment_method: FactoryGirl.build(:payment_method).attributes.except('user_id') }
        end

        it 'creates a new payment method' do
          expect { send_request }.to change { user.payment_methods.count }.by(1)
          expect_status(200)
          expect_response(PaymentMethodSerializer.new(user.payment_methods.last).to_json)
        end
      end
    end
  end

  describe 'put /users/:id/payment_methods/:payment_method_id' do
    let(:method) { :put }
    let(:path) { "/users/#{id}/payment_methods/#{payment_method_id}" }
    let(:payment_method) { PaymentMethod.find FactoryGirl.create(:payment_method, user: user).id }
    let(:payment_method_id) { payment_method.id }
    let(:params) { { payment_method: payment_method.attributes } }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid payment method id' do
        let(:payment_method_id) { rand_str }

        include_examples 'not found'
      end

      context 'valid payment method id' do
        context 'invalid parameters' do
          let(:params) { { payment_method: { balance: nil } } }

          include_examples 'bad request'
        end

        context 'valid parameters' do
          it 'updates the payment method' do
            send_request
            expect_status(200)
            expect_response(PaymentMethodSerializer.new(payment_method).to_json)
          end
        end
      end
    end
  end
end
