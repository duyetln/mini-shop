require 'models/serializers/base'
require 'models/serializers/shopping'
require 'models/serializers/shared'

class OwnershipSerializer < ServiceResourceSerializer
  include ItemCombinableSerializer
  include DeletableSerializer
  attributes :user_id, :order_id
end

class ShipmentSerializer < ServiceResourceSerializer
  include ItemCombinableSerializer
  attributes :user_id, :order_id, :shipping_address_id
  has_one :shipping_address, serializer: 'AddressSerializer'
end
