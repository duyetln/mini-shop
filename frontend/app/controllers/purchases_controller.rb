class PurchasesController < ApplicationController
  def return
    redirect_to sign_in_account_path and return unless logged_in?
    @user = current_user
    @purchase = @user.purchases.find { |purchase| purchase.id == params.require(:id).to_i }
    @purchase.return! if @purchase.present?
    redirect_to :back
  end
end
