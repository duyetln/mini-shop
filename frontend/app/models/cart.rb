class Cart
  class Item
    attr_reader :cart
    attr_reader :orderable
    attr_reader :item
    attr_reader :qty
    attr_reader :price
    attr_reader :amount
    attr_reader :currency

    def initialize(cart, orderable, qty)
      @cart = cart
      @qty = qty
      @currency = cart.currency
      @orderable = orderable
      @item = @orderable.item
      @price = @orderable.amount(currency)
      @amount = @price * @qty

      # hackery
      if @orderable.resource_type == 'Coupon'
        @qty = 1
        @item = @orderable
      end
    end
  end

  attr_accessor :currency
  attr_accessor :payment_method
  attr_accessor :shipping_address
  attr_reader :items

  delegate :size, to: :items
  delegate :count, to: :items
  delegate :clear, to: :items

  def initialize(currency, payment_method = nil, shipping_address = nil)
    @currency = currency
    @payment_method = payment_method
    @shipping_address = shipping_address
    @items = []
  end

  def update(orderable, qty)
    remove(orderable)
    items << Cart::Item.new(self, orderable, qty) if qty > 0
    self
  end

  def remove(orderable)
    items.reject! { |item| item.orderable == orderable }
    self
  end

  def amount
    items.reduce(BigDecimal.new('0.0')) { |amount, item| amount += item.amount }
  end
end
