user = User.last
currency = Currency.find_by_code('USD')
address = Address.where(user_id: user.id, line1: '2800 E Observatory Ave', city: 'Los Angeles', region: 'CA', postal_code: '90027', country: 'US').first_or_create
payment_method = PaymentMethod.where(user_id: user.id, name: 'My online pocket', currency_id: currency.id).first_or_create(balance: 50_000, billing_address_id: address.id)

# 1st purchase
StoreItem.first(3).each do |store_item|
  purchase = user.purchases.create!
  purchase.payment_method   = payment_method
  purchase.shipping_address = address
  purchase.save!

  promotion  = Promotion.last
  coupon = Coupon.joins(batch: :promotion).where(promotions: { id: promotion.id }, used: false).first

  purchase.add_or_update(store_item.item, store_item.amount(currency) * 2, currency, 2)
  purchase.add_or_update(coupon, promotion.amount(currency) * 1, currency, 1)
  purchase.commit!
  purchase.pay!
  purchase.fulfill!
end

Purchase.first.reverse!

# 2nd purchase
purchase = user.purchases.create!
purchase.payment_method   = payment_method
purchase.shipping_address = address
purchase.save!

store_item = StoreItem.last
promotion  = Promotion.last
coupon = Coupon.joins(batch: :promotion).where(promotions: { id: promotion.id }, used: false).first

purchase.add_or_update(store_item.item, store_item.amount(currency) * 2, currency, 2)
purchase.add_or_update(coupon, promotion.amount(currency) * 1, currency, 1)
