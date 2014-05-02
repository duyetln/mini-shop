user = User.first
currency = Currency.find_by_code('USD')
address = Address.where(user_id: user.id, line1: '2800 E Observatory Ave', city: 'Los Angeles', region: 'CA', postal_code: '90027', country: 'US').first_or_create
payment_method = PaymentMethod.where(user_id: user.id, name: 'My online pocket', currency_id: currency.id).first_or_create(balance: 50_000)

purchase = Purchase.pending_purchase(user)
purchase.payment_method   = payment_method
purchase.billing_address  = address
purchase.shipping_address = address
purchase.save!
purchase.add_or_update(StorefrontItem.last, currency, 2)
