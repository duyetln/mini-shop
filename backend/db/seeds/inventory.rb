art_book    = PhysicalItem.where(title: 'StarCraft 2 Art Book').first_or_create!(qty: 25 + rand(15))
mousepad    = PhysicalItem.where(title: 'Zerg Rush Mousepad').first_or_create!(qty: 25 + rand(15))
dvd_set     = PhysicalItem.where(title: 'Behind the Scenes DVD Set').first_or_create!(qty: 25 + rand(15))
soundtrack  = PhysicalItem.where(title: 'StarCraft 2 Soundtrack').first_or_create!(qty: 25 + rand(15))
sc2_retail  = PhysicalItem.where(title: 'StarCraft 2 Retail Edition').first_or_create!(qty: 25 + rand(15))

skin        = DigitalItem.where(title: 'Skin, Portraits, and Decals').first_or_create!
pet         = DigitalItem.where(title: 'World of Warcraft Banneling Pet').first_or_create!
wings       = DigitalItem.where(title: 'Diablo 3 Blade Wings and Banner Sigil').first_or_create!
sc2_digital = DigitalItem.where(title: 'StarCraft 2 Digital Edition').first_or_create!

deluxe_ed    = Bundle.where(title: 'StarCraft 2 Deluxe Edition').first_or_create!
collector_ed = Bundle.where(title: "StarCraft 2 Collector's Edition").first_or_create!

deluxe_ed.bundleds.destroy_all
[sc2_digital, skin, pet, wings].each { |asset| deluxe_ed.add_or_update(asset) }
collector_ed.bundleds.destroy_all
[sc2_retail, art_book, mousepad, dvd_set, soundtrack, skin, pet, wings].each { |asset| collector_ed.add_or_update(asset) }

usd = Currency.where(code: 'USD').first_or_create!
eur = Currency.where(code: 'EUR').first_or_create!
krw = Currency.where(code: 'KRW').first_or_create!
gbp = Currency.where(code: 'GBP').first_or_create!

no_discount =
Discount.where(name: 'No discount', rate: 0.0).first_or_create!
Discount.where(name: 'Black Friday Discount', rate: 0.75).first_or_create!(start_at: DateTime.new(2013, 11, 25), end_at: DateTime.new(2013, 12, 9))
Discount.where(name: 'Christmas Discount', rate: 0.5).first_or_create!(start_at: DateTime.new(2013, 12, 23), end_at: DateTime.new(2013, 12, 30))

sc2_standard_pp = Pricepoint.where(name: 'SC2 Standard Pricepoint').first_or_create!
deluxe_ed_pp    = Pricepoint.where(name: 'SC2 Deluxe Pricepoint').first_or_create!
collector_ed_pp = Pricepoint.where(name: 'SC2 Collector Pricepoint').first_or_create!

sc2_standard_pp.pricepoint_prices.where(currency_id: usd.id).first_or_create!(amount: 59.99)
sc2_standard_pp.pricepoint_prices.where(currency_id: eur.id).first_or_create!(amount: 44.27)
sc2_standard_pp.pricepoint_prices.where(currency_id: krw.id).first_or_create!(amount: 63907.35)
sc2_standard_pp.pricepoint_prices.where(currency_id: gbp.id).first_or_create!(amount: 35.83)

deluxe_ed_pp.pricepoint_prices.where(currency_id: usd.id).first_or_create!(amount: 79.99)
deluxe_ed_pp.pricepoint_prices.where(currency_id: eur.id).first_or_create!(amount: 59.03)
deluxe_ed_pp.pricepoint_prices.where(currency_id: krw.id).first_or_create!(amount: 85213.35)
deluxe_ed_pp.pricepoint_prices.where(currency_id: gbp.id).first_or_create!(amount: 47.78)

collector_ed_pp.pricepoint_prices.where(currency_id: usd.id).first_or_create!(amount: 99.99)
collector_ed_pp.pricepoint_prices.where(currency_id: eur.id).first_or_create!(amount: 73.80)
collector_ed_pp.pricepoint_prices.where(currency_id: krw.id).first_or_create!(amount: 106530.00)
collector_ed_pp.pricepoint_prices.where(currency_id: gbp.id).first_or_create!(amount: 59.72)

sc2_standard_price = Price.where(pricepoint_id: sc2_standard_pp.id).first_or_create!(name: 'SC2 Standard Price', discount_id: no_discount.id)
deluxe_ed_price    = Price.where(pricepoint_id: deluxe_ed_pp.id).first_or_create!(name: 'SC2 Deluxe Price', discount_id: no_discount.id)
collector_ed_price = Price.where(pricepoint_id: collector_ed_pp.id).first_or_create!(name: 'SC2 Collector Price', discount_id: no_discount.id)

StoreItem.where(item_type: sc2_retail.class,   item_id: sc2_retail.id,    price_id: sc2_standard_price.id).first_or_create!(name: 'StarCraft 2 Retail Edition')
StoreItem.where(item_type: sc2_digital.class,  item_id: sc2_digital.id,   price_id: sc2_standard_price.id).first_or_create!(name: 'StarCraft 2 Digital Edition')
StoreItem.where(item_type: deluxe_ed.class,    item_id: deluxe_ed.id,     price_id: deluxe_ed_price.id).first_or_create!(name: 'StarCraft 2 Deluxe Edition')
StoreItem.where(item_type: collector_ed.class, item_id: collector_ed.id,  price_id: collector_ed_price.id).first_or_create!(name: "StarCraft 2 Collector's Edition")
