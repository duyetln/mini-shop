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
      offset(offset || 0).limit(limit || 20)
    end

  end

  def available?
    !removed? && active?
  end

  def activate!
    self.active = true
    save
  end

  def deactivate!
    self.active = false
    save
  end

  def delete!
    self.removed = true
    save
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