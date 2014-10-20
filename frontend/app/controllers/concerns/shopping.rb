module Shopping
  def current_cart
    session[:cart] ||= Cart.new(@currency)
  end
end
