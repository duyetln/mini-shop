class DigitalSku < ActiveRecord::Base

  validates :title, presence: true

  def available?
    self.active?
  end

  def fulfill!(order)
  
  end

end