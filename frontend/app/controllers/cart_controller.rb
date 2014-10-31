class CartController < ApplicationController
  before_action :sign_in!, only: [:payment, :prepare, :review, :submit]

  def show
  end

  def update
    unless orderable.available?
      flash[:error] = 'The item you selected is not available for purchase'
      go_back and return
    end
    @cart.update(orderable, qty)
    flash[:info] = qty > 0 ? "You have added #{orderable.title}" : "You have removed #{orderable.title}"
    go_back
  end

  def remove
    @cart.remove(orderable)
    flash[:info] = "You have removed #{orderable.title}"
    go_back
  end

  def clear
    @cart.clear
    flash[:info] = 'You have cleared your cart'
    go_back
  end

  def payment
  end

  def prepare
    shipping_address_id = params.require(:shipping_address_id).to_i
    payment_method_id = params.require(:payment_method_id).to_i
    @cart.payment_method = @user.payment_methods.find { |payment_method| payment_method.id == payment_method_id }
    @cart.shipping_address = @user.addresses.find { |address| address.id == shipping_address_id }
    flash[:success] = 'You have selected payment method and shipping address'
    go_back
  end

  def review
  end

  def submit
  end

  protected

  def orderable_type
    params.require(:orderable_type)
  end

  def orderable_id
    params.require(:orderable_id)
  end

  def orderable
    @orderable ||= BackendClient.const_get(orderable_type).find(orderable_id)
  end

  def qty
    (params[:qty] || 1).to_i
  end
end
