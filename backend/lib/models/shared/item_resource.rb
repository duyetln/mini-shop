require 'models/shared/activable'
require 'models/shared/deletable'
require 'models/shared/displayable'
require 'models/shared/fulfillable'

module ItemResource
  extend ActiveSupport::Concern
  include Activable
  include Deletable
  include Displayable
  include Fulfillable

  module ClassMethods
    def paginate(offset = nil, limit = nil)
      offset(offset || 0).limit(limit || 20)
    end
  end

  def available?
    kept?
  end

  def activable?
    available? && super
  end

  def deletable?
    inactive? && super
  end
end
