require 'models/shared/committable'

class Transaction < ActiveRecord::Base
  include Committable

  attr_protected :uuid
  attr_readonly :uuid, :user_id, :payment_method_id, :amount, :currency_id

  belongs_to :payment_method, inverse_of: :transactions
  belongs_to :user, inverse_of: :transactions
  belongs_to :currency

  validates :payment_method, presence: true
  validates :currency, presence: true
  validates :amount, presence: true
  validates :uuid, uniqueness: true
  validates :user, presence: true

  after_initialize :initialize_values

  delegate :currency, to: :payment_method, prefix: true

  def commit!
    if pending? && super
      process_transaction!
    end
    committed?
  end

  protected

  def initialize_values
    if new_record?
      self.uuid = SecureRandom.hex.upcase
    end
  end

  def process_transaction!
    fail 'Must be implemented in derived classes'
  end
end
