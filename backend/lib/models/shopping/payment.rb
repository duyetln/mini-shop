require 'models/shared/committable'

class Payment < ActiveRecord::Base

  include Committable

  belongs_to :payment_method
  belongs_to :billing_address, class_name: 'Address'

  attr_protected :uuid, :refunded
  attr_readonly :uuid, :user_id, :payment_method_id, :billing_address_id, :amount, :currency_id

  belongs_to :user
  belongs_to :currency

  validates :amount,  numericality: { greater_than: 0 }

  validates :user,            presence: true
  validates :payment_method,  presence: true
  validates :billing_address, presence: true
  validates :currency, presence: true
  validates :amount,   presence: true

  after_initialize :initialize_values

  delegate :currency, to: :payment_method, prefix: true

  def commit!
    if super
      payment_method.balance -= Currency.exchange(
        amount, 
        currency, 
        payment_method_currency
      )
      payment_method.save!
    end
  end

  protected

  def initialize_values
    if new_record?
      self.uuid = SecureRandom.hex.upcase
      self.refunded = false
    end
  end
end