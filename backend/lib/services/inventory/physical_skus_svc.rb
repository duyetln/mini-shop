class PhysicalSkusSvc < Sinatra::Base
  include SkuSvc

  set :sku_class, PhysicalSku
  set :namespace, sku_class.to_s.tableize

  generate!
end