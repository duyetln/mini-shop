class DigitalSkusService < Sinatra::Base
  include SkuService

  set :sku_class, DigitalSku
  set :namespace, sku_class.to_s.tableize

  generate!
end