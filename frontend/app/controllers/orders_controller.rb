class OrdersController < ApplicationController
  before_action :sign_in!

  def return
    @purchase = @user.purchases.find { |purchase| purchase.id == purchase_id.to_i }
    if @purchase.present?
      @purchase.return_order(id)
      flash[:success] = 'Your order has been returned'
    end
    go_back
  end

  protected

  def purchase_id
    params.require(:purchase_id)
  end
end
