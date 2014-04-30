require 'models/shared/committable'

class Transaction < ActiveRecord::Base
  include Committable

  attr_protected :uuid
  attr_readonly :uuid, :user_id, :payment_method_id, :billing_address_id, :amount, :currency_id

  belongs_to :payment_method
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :user
  belongs_to :currency

  validates :user,            presence: true
  validates :payment_method,  presence: true
  validates :billing_address, presence: true
  validates :currency, presence: true
  validates :amount,   presence: true
  validates :uuid, uniqueness: true

  after_initialize :initialize_values

  delegate :currency, to: :payment_method, prefix: true

  def commit!
    if super
      method = payment? ? :withdraw! : :deposit!
      payment_method.send(method, amount, currency)
    end
  end

  def payment?
    amount >= 0
  end

  def refund?
    !payment?
  end

  protected

  def initialize_values
    if new_record?
      self.uuid = SecureRandom.hex.upcase
    end
  end
end
