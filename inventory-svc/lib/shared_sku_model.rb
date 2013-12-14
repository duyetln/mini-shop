module SharedSkuModel
  extend ActiveSupport::Concern

  included do
    attr_accessible :title, :description

    validates :title, presence: true

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :removed,  -> { where(removed: true) }
    scope :retained, -> { where(removed: false) }

    before_create :set_flags
  end

  def available?
    !self.removed? && self.active?
  end

  def activate!
    self.active = true
    self.save
  end

  def deactivate!
    self.active = false
    self.save
  end

  def delete!
    self.removed = true
    self.save
  end

  def fulfill!(order)
  end

  protected

  def set_flags
    set_active
    set_retained
    true
  end

  def set_active
    self.active = true
  end

  def set_retained
    self.removed = false
  end

end