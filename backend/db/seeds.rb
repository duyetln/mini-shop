art_book    = PhysicalSku.where(title: "StarCraft 2 Art Book").first_or_create(quantity: 25 + rand(15))
mousepad    = PhysicalSku.where(title: "Zerg Rush Mousepad").first_or_create(quantity: 25 + rand(15))
dvd_set     = PhysicalSku.where(title: "Behind the Scenes DVD Set").first_or_create(quantity: 25 + rand(15))
soundtrack  = PhysicalSku.where(title: "StarCraft 2 Soundtrack").first_or_create(quantity: 25 + rand(15))
sc2_retail  = PhysicalSku.where(title: "StarCraft 2 Retail Edition").first_or_create(quantity: 25 + rand(15))

skin        = DigitalSku.where(title: "Skin, Portraits, and Decals").first_or_create
pet         = DigitalSku.where(title: "World of Warcraft Banneling Pet").first_or_create
wings       = DigitalSku.where(title: "Diablo 3 Blade Wings and Banner Sigil").first_or_create
sc2_digital = DigitalSku.where(title: "StarCraft 2 Digital Edition").first_or_create

deluxe_ed    = BundleSku.where(title: "StarCraft 2 Deluxe Edition").first_or_create
collector_ed = BundleSku.where(title: "StarCraft 2 Collector's Edition").first_or_create

[sc2_digital, skin, pet, wings].each { |asset| deluxe_ed.bundlings.where(bundled_sku_type: asset.class, bundled_sku_id: asset.id).first_or_create }
[sc2_retail, art_book, mousepad, dvd_set, soundtrack, skin, pet, wings].each { |asset| collector_ed.bundlings.where(bundled_sku_type: asset.class, bundled_sku_id: asset.id).first_or_create }

usd = Currency.where(code: "USD").first_or_create
eur = Currency.where(code: "EUR").first_or_create
krw = Currency.where(code: "KRW").first_or_create

no_discount           = Discount.where(name: "No discount", rate: 0.0).first_or_create
black_friday_discount = Discount.where(name: "Black Friday Discount", rate: 0.75).first_or_create(start_at: DateTime.new(2013,11,25), end_at: DateTime.new(2013,12,9))
christmas_discount    = Discount.where(name: "Christmas Discount", rate: 0.5).first_or_create(start_at: DateTime.new(2013,12,23), end_at: DateTime.new(2013,12,30))

sc2_standard_pp = Pricepoint.where(name: "SC2 Standard Pricepoint").first_or_create
deluxe_ed_pp    = Pricepoint.where(name: "SC2 Deluxe Pricepoint").first_or_create
collector_ed_pp = Pricepoint.where(name: "SC2 Collector Pricepoint").first_or_create

sc2_standard_pp.pricepoint_prices.where(currency_id: usd.id).first_or_create(amount: 59.99)
sc2_standard_pp.pricepoint_prices.where(currency_id: eur.id).first_or_create(amount: 44.27)
sc2_standard_pp.pricepoint_prices.where(currency_id: krw.id).first_or_create(amount: 63907.35)

deluxe_ed_pp.pricepoint_prices.where(currency_id: usd.id).first_or_create(amount: 79.99)
deluxe_ed_pp.pricepoint_prices.where(currency_id: eur.id).first_or_create(amount: 59.03)
deluxe_ed_pp.pricepoint_prices.where(currency_id: krw.id).first_or_create(amount: 85213.35)

collector_ed_pp.pricepoint_prices.where(currency_id: usd.id).first_or_create(amount: 99.99)
collector_ed_pp.pricepoint_prices.where(currency_id: eur.id).first_or_create(amount: 73.80)
collector_ed_pp.pricepoint_prices.where(currency_id: krw.id).first_or_create(amount: 106530.00)

sc2_standard_price = Price.where(pricepoint_id: sc2_standard_pp.id).first_or_create(name: "SC2 Standard Price", discount_id: no_discount.id)
deluxe_ed_price    = Price.where(pricepoint_id: deluxe_ed_pp.id).first_or_create(name: "SC2 Deluxe Price", discount_id: no_discount.id)
collector_ed_price = Price.where(pricepoint_id: collector_ed_pp.id).first_or_create(name: "SC2 Collector Price", discount_id: no_discount.id)

StorefrontSku.where(sku_type: sc2_retail.class,   sku_id: sc2_retail.id,    price_id: sc2_standard_price.id).first_or_create(title: "StarCraft 2 Retail Edition")
StorefrontSku.where(sku_type: sc2_digital.class,  sku_id: sc2_digital.id,   price_id: sc2_standard_price.id).first_or_create(title: "StarCraft 2 Digital Edition")
StorefrontSku.where(sku_type: deluxe_ed.class,    sku_id: deluxe_ed.id,     price_id: deluxe_ed_price.id).first_or_create(title: "StarCraft 2 Deluxe Edition")
StorefrontSku.where(sku_type: collector_ed.class, sku_id: collector_ed.id,  price_id: collector_ed_price.id).first_or_create(title: "StarCraft 2 Collector's Edition")