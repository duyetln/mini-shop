require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Shopping::Addresses do
  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }
    let(:user) { FactoryGirl.create(:user).reload }
    let(:address) { FactoryGirl.create(:address, user: user) }
    let(:id) { address.id }
    let(:params) { { address: address.attributes } }

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { { address: { line1: nil } } }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        it 'updates the address' do
          send_request
          expect_status(200)
          expect_response(AddressSerializer.new(address).to_json)
        end
      end
    end
  end
end
