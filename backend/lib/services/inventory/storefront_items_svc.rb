require "services/shared/item_svc"

class StorefrontItemsSvc < Sinatra::Base
  include ItemSvc

  set :item_class, StorefrontItem
  set :namespace, item_class.to_s.tableize

  generate!
end