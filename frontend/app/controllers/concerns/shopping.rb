module Shopping
  def currencies
    session[:currencies] ||= BackendClient::Currency.all
  end

  def current_currency
    currencies.find { |currency| currency.code == 'USD' }
  end

  def current_cart
    session[:cart] ||= Cart.new(@currency)
  end
end
