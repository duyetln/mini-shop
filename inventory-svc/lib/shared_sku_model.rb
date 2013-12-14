module SharedSkuModel
  extend ActiveSupport::Concern

  included do
    validates :title, presence: true
    scope :active,   where(active: true)
    scope :inactive, where(active: false)

    before_create :set_active 
  end

  def set_active
    self.active = true if self.active.nil?
  end

  def available?
    self.active?
  end

  def activate!
    self.active = true
    self.save
  end

  def deactivate!
    self.active = false
    self.save
  end

  def fulfill!(order)
  end

end