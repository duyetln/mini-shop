require 'models/shared/enum'
require 'models/shared/itemable'

class Fulfillment < ActiveRecord::Base

  class PreparationFailure < StandardError; end
  class FulfillmentFailure < StandardError; end
  class ReversalFailure    < StandardError; end

  include Enum
  include Itemable

  enum :status, [ :prepared, :fulfilled, :reversed ]

  attr_protected :status, :fulfilled_at, :reversed_at
  attr_readonly :order_id

  belongs_to :order

  validates :order, presence: true

  validates :item_type, inclusion: { in: %w{ PhysicalItem DigitalItem } }

  after_initialize :initialize_values

  def self.prepare!(order, item)
    fulfillment = new
    fulfillment.order = order
    fulfillment.item  = item
    fulfillment.save!

    fulfillment.prepared? || ( raise PreparationFailure )
  end

  def fulfill!
    if persisted? && prepared? && process_fulfillment!
      self.status = STATUS[:fulfilled]
      self.fulfilled_at = DateTime.now
      save!
    end
    fulfilled? || ( raise FulfillmentFailure )
  end

  def reverse!
    if persisted? && fulfilled? && process_reversal!
      self.status = STATUS[:reversed]
      self.reversed_at = DateTime.now
      save!
    end
    reversed? || ( raise ReversalFailure )
  end

  protected

  def process_fulfillment!
    raise 'Must be implemented in derived class'
  end

  def process_reversal!
    raise 'Must be implemented in derived class'
  end

  def initialize_values
    if new_record?
      self.status = STATUS[:prepared]
      self.fulfilled_at = nil
      self.reversed_at  = nil
    end
  end

end