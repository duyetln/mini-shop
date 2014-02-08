class DigitalSkusSvc < Sinatra::Base
  include SkuSvc

  set :sku_class, DigitalSku
  set :namespace, sku_class.to_s.tableize

  generate!
end