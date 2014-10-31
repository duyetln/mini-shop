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
    go_back review_cart_path
  end

  def review
    unless @cart.size > 0
      flash[:error] = 'Please select a few items for purchase'
      go_back store_path and return
    end

    unless @cart.payment_method.present? && @cart.shipping_address.present?
      flash[:error] = 'Please provide payment method and shipping address'
      go_back payment_cart_path and return
    end

    @purchase = @user.purchases(page: 1, size: 1).first
    if @purchase.blank? || @purchase.committed?
      @purchase = @user.create_purchase(
        payment_method_id: @cart.payment_method.id,
        shipping_address_id: @cart.shipping_address.id
      )
    end
    @purchase.orders.each do |order|
      unless @cart.items.map(&:item).include?(order.item)
        @purchase.delete_order(order.id)
      end
    end
    @cart.items.each do |item|
      @purchase.add_or_update_order(
        item_type: item.item.resource_type,
        item_id: item.item.resource_id,
        currency_id: item.currency.id,
        amount: item.amount,
        qty: item.qty
      )
      session[:purchase] = @purchase
      @payment_method = @purchase.payment_method
      @shipping_address = @purchase.shipping_address
    end
  end

  def submit
    @purchase = session[:purchase]
    unless @purchase.present?
      flash[:error] = 'Please select a few items for purchase'
      go_back review_path and return
    end
    @purchase.submit!
    session[:purchase] = nil
    session[:cart] = nil
    flash[:success] = 'Your purchase has been submitted and is being processed'
    go_back account_path
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
