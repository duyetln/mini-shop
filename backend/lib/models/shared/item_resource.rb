require "models/shared/activable"
require "models/shared/deletable"
require "models/shared/displayable"

module ItemResource

  extend ActiveSupport::Concern
  include Activable
  include Deletable
  include Displayable

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

  protected

  def set_values
    self.active  = true
    self.deleted = false
    true
  end

end