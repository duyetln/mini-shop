module SkuResource
  extend ActiveSupport::Concern

  included do
    attr_accessible :title, :description

    validates :title, presence: true

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :removed,  -> { where(removed: true) }
    scope :kept, -> { where(removed: false) }

    before_create :set_values
  end

  module ClassMethods

    def paginate(offset=nil, limit=nil)
      offset(offset || 0).limit(limit || 20)
    end

  end

  def available?
    !removed? && active?
  end

  def activate!
    if persisted?
      self.active = true
      save
    end
  end

  def deactivate!
    if persisted?
      self.active = false
      save
    end
  end

  def delete!
    if persisted?
      self.removed = true
      save
    end
  end

  def fulfill!(order)
  end

  protected

  def set_values
    self.active  = true
    self.removed = false
    true
  end

end