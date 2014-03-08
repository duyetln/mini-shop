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

    after_initialize :initialize_values
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

  def initialize_values
    if new_record?
      self.active  = true
      self.deleted = false
    end
  end

end