require 'models/serializers/base'
require 'models/serializers/shopping'
require 'models/serializers/shared'

class OwnershipSerializer < ResourceSerializer
  include ItemCombinableSerializer
  include DeletableSerializer
  attributes :user_id, :order_id, :purchase_id

  def purchase_id
    object.order.purchase.id
  end
end

class ShipmentSerializer < ResourceSerializer
  include ItemCombinableSerializer
  attributes :user_id, :order_id, :purchase_id, :shipping_address_id
  has_one :shipping_address, serializer: 'AddressSerializer'

  def purchase_id
    object.order.purchase.id
  end
end
