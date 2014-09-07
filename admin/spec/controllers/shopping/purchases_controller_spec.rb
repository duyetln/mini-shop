# module Shopping
#   class PurchasesController < ApplicationController
#     def show
#       @purchase = Purchase.find(id)
#       @payment_method = @purchase.payment_method
#       @billing_address = @purchase.billing_address
#       @shipping_address = @purchase.shipping_address
#       @orders = @purchase.orders
#       @payment = @purchase.payment
#       @user = @purchase.user
#     end

#     def return
#       @purchase = Purchase.find(id)
#       @purchase.return!
#       flash[:success] = 'Purchase refunded successfuly' and go_back
#     end
#   end
# end

require 'controllers/spec_setup'

describe Shopping::PurchasesController do
  let(:resource_class) { BackendClient::Purchase }
  let(:resource) { purchase }

  render_views

  describe '#show' do
    let(:method) { :get }
    let(:action) { :show }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:user).at_least(:once).and_return(user)
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#return' do
    let(:method) { :put }
    let(:action) { :return }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:return!)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
