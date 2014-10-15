class OrdersController < ApplicationController
  def return
    redirect_to sign_in_account_path and return unless logged_in?
    @user = current_user
    @purchase = @user.purchases.find { |purchase| purchase.id == params.require(:purchase_id).to_i }
    @purchase.return_order(params.require(:id))
    redirect_to :back
  end
end
