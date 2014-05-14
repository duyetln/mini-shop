require 'services/serializers/base'
require 'services/serializers/shopping'

class OwnershipSerializer < ResourceSerializer
  attributes :user_id, :order_id, :item_type, :item_id, :qty, :deleted, :created_at
  has_one :item, serializer: DynamicSerializer
end

class ShipmentSerializer < ResourceSerializer
  attributes :user_id, :order_id, :item_type, :item_id, :qty, :shipping_address_id, :created_at
  has_one :item, serializer: DynamicSerializer
  has_one :shipping_address, serializer: AddressSerializer
end
