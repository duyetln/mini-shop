require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Shopping::Addresses do
  let :user do
    User.find FactoryGirl.create(:user).id
  end
  let(:id) { user.id }

  describe 'get /users/:id/addresses' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/addresses" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the addresses' do
        send_request
        expect_status(200)
        expect_response(user.addresses.map do |address|
          AddressSerializer.new(address)
        end.to_json)
      end
    end
  end

  describe 'post /users/:id/addresses' do
    let(:method) { :post }
    let(:path) { "/users/#{id}/addresses" }

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
          { address: FactoryGirl.build(:address).attributes.except('user_id') }
        end

        it 'creates a new address' do
          expect { send_request }.to change { user.addresses.count }.by(1)
          expect_status(200)
          expect_response(AddressSerializer.new(user.addresses.last).to_json)
        end
      end
    end
  end

  describe 'put /users/:id/addresses/:address_id' do
    let(:method) { :put }
    let(:path) { "/users/#{id}/addresses/#{address_id}" }
    let(:address) { Address.find FactoryGirl.create(:address, user: user).id }
    let(:address_id) { address.id }
    let(:params) { { address: address.attributes } }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid address id' do
        let(:address_id) { rand_str }

        include_examples 'not found'
      end

      context 'valid address id' do
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
end
