class PaymentMethodsController < ApplicationController
  def update
    redirect_to sign_in_account_path and return unless logged_in?
    @params = params.require(:payment_method).permit(:balance)
    @user = current_user
    @payment_method = @user.payment_methods.find { |payment_method| payment_method.id == params.require(:id).to_i }

    if @payment_method.present?
      @payment_method.merge!(@params)
      @payment_method.update!(:balance)
    end

    redirect_to :back
  end
end
