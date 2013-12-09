class PhysicalSku < ActiveRecord::Base

  validates :title,    presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  before_create :set_quantity

  def set_quantity
    self.quantity ||= 0
  end

  def available?
    self.active? && self.quantity > 0
  end

  def fulfill!(order)
  
  end

end