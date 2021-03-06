require 'models/serializers/base'
require 'models/serializers/shared'

class AddressSerializer < ResourceSerializer
  attributes :user_id, :line1, :line2, :line3, :city, :region, :postal_code, :country
end

class PaymentMethodSerializer < ResourceSerializer
  attributes :user_id, :name, :balance, :pending_balance, :currency_id, :billing_address_id
  has_one :currency, serializer: 'CurrencySerializer'
  has_one :billing_address, serializer: 'AddressSerializer'
end

class TransactionSerializer < ResourceSerializer
  include CommittableSerializer
  attributes :user_id, :uuid, :payment_method_id, :amount, :currency_id
  has_one :currency, serializer: 'CurrencySerializer'
  has_one :payment_method, serializer: 'PaymentMethodSerializer'
end

class RefundTransactionSerializer < TransactionSerializer; end
class PaymentTransactionSerializer < TransactionSerializer; end

class OrderSerializer < ResourceSerializer
  include ItemCombinableSerializer
  include DeletableSerializer
  attributes :uuid, :purchase_id, :currency_id, :amount, :tax, :tax_rate, :total, :qty, :refund_transaction_id, :status_id
  has_one :currency, serializer: 'CurrencySerializer'
  has_one :refund_transaction, serializer: 'RefundTransactionSerializer'
  has_many :statuses, serializer: 'StatusSerializer'

  def status_id
    object.status.try(:id)
  end

  [:unmarked, :marked, :failed, :invalid, :fulfilled, :reversed].each do |key|
    attributes key
    define_method key do
      object.send("#{key}?")
    end
  end
end

class PurchaseSerializer < ResourceSerializer
  include ChangeableSerializer
  attributes :user_id, :payment_method_id, :shipping_address_id, :payment_transaction_id, :committed, :committed_at, :amount, :tax, :total, :paid_amount, :refund_amount, :charge_amount, :paid, :free
  has_one :payment_method, serializer: 'PaymentMethodSerializer'
  has_one :shipping_address, serializer: 'AddressSerializer'
  has_one :payment_transaction, serializer: 'PaymentTransactionSerializer'
  has_one :currency, serializer: 'CurrencySerializer'
  has_many :orders, serializer: 'OrderSerializer'

  def paid
    object.paid?
  end

  def free
    object.free?
  end
end
