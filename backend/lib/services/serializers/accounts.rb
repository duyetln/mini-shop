require 'services/serializers/base'
require 'services/serializers/shopping'

class UserSerializer < ResourceSerializer
  attributes :uuid, :first_name, :last_name, :email, :birthdate, :actv_code, :confirmed
  attributes :address_ids, :payment_method_ids
  has_many :addresses, serializer: 'AddressSerializer'
  has_many :payment_methods, serializer: 'PaymentMethodSerializer'

  def address_ids
    object.addresses.map(&:id)
  end

  def payment_method_ids
    object.payment_methods.map(&:id)
  end
end
