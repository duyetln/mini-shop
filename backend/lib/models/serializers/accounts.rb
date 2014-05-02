require 'models/serializers/base'
require 'models/serializers/shopping'

class UserSerializer < ResourceSerializer
  attributes :uuid, :first_name, :last_name, :email, :birthdate, :actv_code, :confirmed
  has_many :addresses, serializer: AddressSerializer
  has_many :payment_methods, serializer: PaymentMethodSerializer
end
