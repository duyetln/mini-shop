class Fulfillment < ActiveRecord::Base

  class PreparationFailure < StandardError; end
  class FulfillmentFailure < StandardError; end
  class ReversalFailure    < StandardError; end

  include Enum

  enum :status, [ :prepared, :fulfilled, :reversed ]

  attr_accessible :order_id, :item_type, :item_id

  ITEM_TYPES = [ "PhysicalItem", "DigitalItem" ]

  belongs_to :order
  belongs_to :item, polymorphic: true

  validates :order_id,  presence: true
  validates :item_type, presence: true
  validates :item_type, inclusion: { in: ITEM_TYPES }
  validates :item_id,   presence: true

  validates :order, presence: true
  validates :item,  presence: true

  before_create :set_values

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
    raise "Must be implemented in derived class"
  end

  def process_reversal!
    raise "Must be implemented in derived class"
  end

  def set_values
    self.status = STATUS[:prepared]
    self.fulfilled_at = nil
    self.reversed_at  = nil
    true
  end

end