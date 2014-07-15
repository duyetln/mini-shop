art_book    = PhysicalItem.create!(title: 'StarCraft 2 Art Book', qty: 25 + rand(15))
mousepad    = PhysicalItem.create!(title: 'Zerg Rush Mousepad', qty: 25 + rand(15))
dvd_set     = PhysicalItem.create!(title: 'Behind the Scenes DVD Set', qty: 25 + rand(15))
soundtrack  = PhysicalItem.create!(title: 'StarCraft 2 Soundtrack', qty: 25 + rand(15))
sc2_retail  = PhysicalItem.create!(title: 'StarCraft 2 Retail Edition', qty: 25 + rand(15))

skin        = DigitalItem.create!(title: 'Skin, Portraits, and Decals')
pet         = DigitalItem.create!(title: 'World of Warcraft Banneling Pet')
wings       = DigitalItem.create!(title: 'Diablo 3 Blade Wings and Banner Sigil')
sc2_digital = DigitalItem.create!(title: 'StarCraft 2 Digital Edition')

deluxe_ed    = Bundle.create!(title: 'StarCraft 2 Deluxe Edition')
collector_ed = Bundle.create!(title: 'StarCraft 2 Collector\'s Edition')

deluxe_ed.bundleds.destroy_all
[sc2_digital, skin, pet, wings].each { |asset| deluxe_ed.add_or_update(asset) }
collector_ed.bundleds.destroy_all
[sc2_retail, art_book, mousepad, dvd_set, soundtrack, skin, pet, wings].each { |asset| collector_ed.add_or_update(asset) }

usd = Currency.create!(code: 'USD', sign: '&#36;')
eur = Currency.create!(code: 'EUR', sign: '&#128;')
krw = Currency.create!(code: 'KRW', sign: '&#8361;')
gbp = Currency.create!(code: 'GBP', sign: '&#163;')

half_discount = Discount.create!(name: 'Half Discount', rate: 0.5)
no_discount   = Discount.create!(name: 'No Discount', rate: 0.0)
Discount.create!(name: 'Full Discount', rate: 1.0)
Discount.create!(name: 'Black Friday Discount', rate: 0.75, start_at: DateTime.new(2013, 11, 25), end_at: DateTime.new(2013, 12, 9))
Discount.create!(name: 'Christmas Discount', rate: 0.5, start_at: DateTime.new(2013, 12, 23), end_at: DateTime.new(2013, 12, 30))

free_pp         = Pricepoint.create!(name: 'Free Pricepoint')
sc2_standard_pp = Pricepoint.create!(name: 'SC2 Standard Pricepoint')
deluxe_ed_pp    = Pricepoint.create!(name: 'SC2 Deluxe Pricepoint')
collector_ed_pp = Pricepoint.create!(name: 'SC2 Collector Pricepoint')

free_pp.pricepoint_prices.create!(currency_id: usd.id, amount: 0.0)
free_pp.pricepoint_prices.create!(currency_id: eur.id, amount: 0.0)
free_pp.pricepoint_prices.create!(currency_id: krw.id, amount: 0.0)
free_pp.pricepoint_prices.create!(currency_id: gbp.id, amount: 0.0)

sc2_standard_pp.pricepoint_prices.create!(currency_id: usd.id, amount: 59.99)
sc2_standard_pp.pricepoint_prices.create!(currency_id: eur.id, amount: 44.27)
sc2_standard_pp.pricepoint_prices.create!(currency_id: krw.id, amount: 63_907.35)
sc2_standard_pp.pricepoint_prices.create!(currency_id: gbp.id, amount: 35.83)

deluxe_ed_pp.pricepoint_prices.create!(currency_id: usd.id, amount: 79.99)
deluxe_ed_pp.pricepoint_prices.create!(currency_id: eur.id, amount: 59.03)
deluxe_ed_pp.pricepoint_prices.create!(currency_id: krw.id, amount: 85_213.35)
deluxe_ed_pp.pricepoint_prices.create!(currency_id: gbp.id, amount: 47.78)

collector_ed_pp.pricepoint_prices.create!(currency_id: usd.id, amount: 99.99)
collector_ed_pp.pricepoint_prices.create!(currency_id: eur.id, amount: 73.80)
collector_ed_pp.pricepoint_prices.create!(currency_id: krw.id, amount: 106_530.00)
collector_ed_pp.pricepoint_prices.create!(currency_id: gbp.id, amount: 59.72)

deluxe_ed_promo_price = Price.create!(name: 'SC2 Deluxe Promotion Price', pricepoint_id: deluxe_ed_pp.id, discount_id: half_discount.id)
sc2_standard_price    = Price.create!(name: 'SC2 Standard Price', pricepoint_id: sc2_standard_pp.id, discount_id: no_discount.id)
deluxe_ed_price       = Price.create!(name: 'SC2 Deluxe Price', pricepoint_id: deluxe_ed_pp.id, discount_id: no_discount.id)
collector_ed_price    = Price.create!(name: 'SC2 Collector Price', pricepoint_id: collector_ed_pp.id, discount_id: no_discount.id)

StoreItem.create!(name: 'StarCraft 2 Retail Edition', item: sc2_retail, price: sc2_standard_price)
StoreItem.create!(name: 'StarCraft 2 Digital Edition', item: sc2_digital, price: sc2_standard_price)
StoreItem.create!(name: 'StarCraft 2 Deluxe Edition', item: deluxe_ed, price: deluxe_ed_price)
StoreItem.create!(name: 'StarCraft 2 Collector\'s Edition', item: collector_ed, price: collector_ed_price)

promotion = Promotion.create!(
  title: 'Starcraft 2 Deluxe Edition 50% Off',
  name: 'Starcraft 2 Deluxe Edition Promotion',
  item: deluxe_ed,
  price: deluxe_ed_promo_price
)
promotion.create_batches(20, 10)

PhysicalItem.all.each(&:activate!)
DigitalItem.all.each(&:activate!)
Bundle.all.each(&:activate!)
Batch.all.each(&:activate!)
Promotion.all.each(&:activate!)
