require 'models/shared/item_combinable'
require 'models/shared/status'

class Fulfillment < ActiveRecord::Base
  class FulfillmentFailure < StandardError; end
  class ReversalFailure    < StandardError; end

  STATUS = { failed: -2, invalid: -1, fulfilled: 1, reversed: 2 }

  include ItemCombinable
  include Status::Mixin

  attr_readonly :order_id

  belongs_to :order, inverse_of: :fulfillments

  validates :order, presence: true
  validates :order_id, uniqueness: { scope: [:item_type, :item_id] }

  validates :item_type, inclusion: { in: %w{ PhysicalItem DigitalItem } }

  def fulfillable?
    unmarked?
  end

  def fulfill!
    if fulfillable?
      process_fulfillment! ? mark_fulfilled! : mark_failed!
      fulfilled?
    end
  end

  def reversible?
    fulfilled?
  end

  def reverse!
    if reversible?
      process_reversal! ? mark_reversed! : mark_failed!
      reversed?
    end
  end

  protected

  def process_fulfillment!
    fail 'Must be implemented in derived class'
  end

  def process_reversal!
    fail 'Must be implemented in derived class'
  end
end
