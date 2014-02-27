class Fulfillment < ActiveRecord::Base

  class FulfillmentFailure < StandardError; end
  class UnfulfillmentFailure < StandardError; end

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

  def fulfill!
    if persisted? && !fulfilled? && process!
      self.fulfilled    = true
      self.fulfilled_at = DateTime.now
      save!
    end

    persisted? && fulfilled? || ( raise FulfillmentFailure )
  end

  protected

  def process!
    raise "Must be implemented in derived class"
  end

  def set_values
    self.fulfilled    = false
    self.fulfilled_at = nil
    true
  end

end