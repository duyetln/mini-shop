class PurchasesController < ApplicationController
  before_action :sign_in!

  def return
    @purchase = @user.purchases.find { |purchase| purchase.id == id.to_i }
    if @purchase.present?
      @purchase.return!
      flash[:success] = 'Your purchase has been returned'
    end
    go_back
  end
end
