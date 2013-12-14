module SharedSkuModel
  extend ActiveSupport::Concern

  included do
    attr_accessible :title, :description

    validates :title, presence: true

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :removed,  -> { where(deleted: true) }
    scope :retained, -> { where(deleted: false) }

    before_create :set_flags
  end

  def available?
    !self.deleted? && self.active?
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
    self.deleted = true
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
    self.deleted = false
  end

end