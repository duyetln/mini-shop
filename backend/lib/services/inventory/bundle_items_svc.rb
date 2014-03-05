require "services/shared/item_svc"

class BundleItemsSvc < Sinatra::Base

  include ItemSvc

  set :item_class, BundleItem
  set :namespace, item_class.to_s.tableize

  generate!
end