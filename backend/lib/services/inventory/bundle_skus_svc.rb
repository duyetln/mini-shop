class BundleSkusSvc < Sinatra::Base
  include SkuSvc

  set :sku_class, BundleSku
  set :namespace, sku_class.to_s.tableize

  generate!
end