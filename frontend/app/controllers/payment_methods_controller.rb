class PaymentMethodsController < ApplicationController
  before_action :sign_in!

  def update
    @params = update_payment_method_params
    @payment_method = @user.payment_methods.find do |payment_method|
      payment_method.id == id.to_i
    end
    begin
      if @payment_method.present?
        @payment_method.merge!(@params)
        @payment_method.update!(:balance)
        flash[:success] = 'Your payment method balance has been updated'
      end
      go_back
    rescue
      @payment_method.reload!
      raise
    end
  end
end
