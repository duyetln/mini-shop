class CartController < ApplicationController
  def show
  end

  def update
    unless orderable.available?
      flash[:error] = 'The item you selected is not available for purchase'
      go_back and return
    end
    current_cart.update(orderable, qty)
    flash[:info] = qty > 0 ? "You have added #{orderable.title}" : "You have removed #{orderable.title}"
    go_back
  end

  def remove
    current_cart.remove(orderable)
    flash[:info] = "You have removed #{orderable.title}"
    go_back
  end

  def clear
    current_cart.clear
    flash[:info] = 'You have cleared your cart'
    go_back
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
    (orderable_type == 'Coupon' ? 1 : (params[:qty] || 1)).to_i
  end
end
