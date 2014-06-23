require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Shopping::PaymentMethods do
  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }
    let(:user) { FactoryGirl.create(:user).reload }
    let(:payment_method) { FactoryGirl.create(:payment_method, user: user) }
    let(:id) { payment_method.id }
    let(:params) { { payment_method: payment_method.attributes } }

    include_examples 'invalid id'

    context 'valid id' do
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
