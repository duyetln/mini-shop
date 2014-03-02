require "services/shared/item_svc"

class DigitalItemsSvc < Sinatra::Base
  include ItemSvc

  set :item_class, DigitalItem
  set :namespace, item_class.to_s.tableize

  generate!
end