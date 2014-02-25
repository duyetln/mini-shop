class Fulfillment < ActiveRecord::Base

  attr_accessible :order_id

  belongs_to :order

  validates :order_id, uniqueness: true
  validates :order_id, presence: true
  validates :order,    presence: true

  before_create :set_values

  def fulfill!
    if pending? && process!
      self.fulfilled    = true
      self.fulfilled_at = DateTime.now
      save
    end
  end

  def pending?
    !fulfilled?
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