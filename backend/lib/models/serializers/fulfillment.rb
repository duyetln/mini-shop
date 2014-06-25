require 'models/serializers/base'
require 'models/serializers/shopping'
require 'models/serializers/shared'

class OwnershipSerializer < ServiceResourceSerializer
  include ItemCombinableSerializer
  include DeletableSerializer
  attributes :user_id, :order_id, :created_at
end

class ShipmentSerializer < ServiceResourceSerializer
  include ItemCombinableSerializer
  attributes :user_id, :order_id, :shipping_address_id, :created_at
  has_one :shipping_address, serializer: 'AddressSerializer'
end
