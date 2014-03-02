require "services/shared/item_svc"

class PhysicalItemsSvc < Sinatra::Base
  include ItemSvc

  set :item_class, PhysicalItem
  set :namespace, item_class.to_s.tableize

  generate!
end