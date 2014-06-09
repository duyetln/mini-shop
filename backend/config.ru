require './boot'

Application.load_lib!
Application.load_models!
Application.load_services!
Application.load_config!

use Rack::Parser, parsers: { 'application/json' => proc { |data| Yajl::Parser.parse data } }

class ApplicationService < Sinatra::Base
  use Services::Accounts::Users
  use Services::Fulfillment::Ownerships
  use Services::Fulfillment::Shipments
  use Services::Inventory::Batches
  use Services::Inventory::Bundles
  use Services::Inventory::Coupons
  use Services::Inventory::Currencies
  use Services::Inventory::DigitalItems
  use Services::Inventory::Discounts
  use Services::Inventory::PhysicalItems
  use Services::Inventory::PricepointPrices
  use Services::Inventory::Pricepoints
  use Services::Inventory::Prices
  use Services::Inventory::Promotions
  use Services::Inventory::StoreItems
  use Services::Shopping::Addresses
  use Services::Shopping::Orders
  use Services::Shopping::PaymentMethods
  use Services::Shopping::Purchases
end

map('/svc') { run ApplicationService }