class PhysicalSkusService < Sinatra::Base
  include SkuService

  set :sku_class, PhysicalSku
  set :namespace, sku_class.to_s.tableize

  generate!
end