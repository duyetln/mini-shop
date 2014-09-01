require 'services/spec_setup'

describe Services::Shopping::PaymentMethods do
  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }
    let(:payment_method) { FactoryGirl.create :payment_method }
    let(:id) { payment_method.id }

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { { payment_method: { balance: nil } } }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let(:params) { { payment_method: { balance: rand_num } } }

        it 'updates the payment method' do
          expect { send_request }.to change { payment_method.reload.attributes }
          expect_status(200)
          expect_response(PaymentMethodSerializer.new(payment_method).to_json)
        end
      end
    end
  end
end
