class StorefrontSkusService < Sinatra::Base
  include SkuService

  set :sku_class, StorefrontSku
  set :namespace, sku_class.to_s.tableize

  generate!
end