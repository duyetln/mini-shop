module ItemResource
  extend ActiveSupport::Concern

  include ActivableScope
  include Activable
  include DeletableScope
  include Deletable
  include Fulfillable

  included do
    attr_accessible :title, :description

    validates :title, presence: true

    before_create :set_values
  end

  module ClassMethods

    def paginate(offset=nil, limit=nil)
      offset(offset || 0).limit(limit || 20)
    end

  end

  def available?
    !deleted? && active?
  end

  def activate!
    if persisted? && !active?
      self.active = true
      save
    end
  end

  def deactivate!
    if persisted? && active?
      self.active = false
      save
    end
  end

  def delete!
    if persisted? && !deleted?
      self.deleted = true
      save
    end
  end

  protected

  def set_values
    self.active  = true
    self.deleted = false
    true
  end

end