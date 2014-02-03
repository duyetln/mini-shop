module SkuResource
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

  module ClassMethods

    def paginate(offset=nil, limit=nil)
      self.offset(offset || 0).limit(limit || 20)
    end

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
    self.active  = true
    self.removed = false
    true
  end

end