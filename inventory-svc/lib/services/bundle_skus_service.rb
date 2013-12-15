class BundleSkusService < Sinatra::Base
  include SkuService

  set :sku_class, BundleSku
  set :namespace, sku_class.to_s.tableize

  generate!
end