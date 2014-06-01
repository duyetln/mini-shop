require 'services/serializers/base'
require 'services/serializers/shopping'
require 'services/serializers/shared'

class OwnershipSerializer < ResourceSerializer
  include ItemCombinableSerializer
  include DeletableSerializer
  attributes :user_id, :order_id, :created_at
end

class ShipmentSerializer < ResourceSerializer
  include ItemCombinableSerializer
  attributes :user_id, :order_id, :shipping_address_id, :created_at
  has_one :shipping_address, serializer: 'AddressSerializer'
end
