class StorefrontSkusSvc < Sinatra::Base
  include SkuSvc

  set :sku_class, StorefrontSku
  set :namespace, sku_class.to_s.tableize

  generate!
end