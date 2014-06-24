require './boot'

use Rack::Parser, parsers: { 'application/json' => proc { |data| Yajl::Parser.parse data } }

map '/svc' do
  run Rack::URLMap.new(
    '/users' => Services::Accounts::Users,
    '/batches' => Services::Inventory::Batches,
    '/bundles' => Services::Inventory::Bundles,
    '/coupons' => Services::Inventory::Coupons,
    '/currencies' => Services::Inventory::Currencies,
    '/digital_items' => Services::Inventory::DigitalItems,
    '/discounts' => Services::Inventory::Discounts,
    '/physical_items' => Services::Inventory::PhysicalItems,
    '/pricepoint_prices' => Services::Inventory::PricepointPrices,
    '/pricepoints' => Services::Inventory::Pricepoints,
    '/prices' => Services::Inventory::Prices,
    '/promotions' => Services::Inventory::Promotions,
    '/store_items' => Services::Inventory::StoreItems,
    '/emails' => Services::Mailing::Emails,
    '/addresses' => Services::Shopping::Addresses,
    '/payment_methods' => Services::Shopping::PaymentMethods,
    '/purchases' => Services::Shopping::Purchases
  )
end
