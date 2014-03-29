require 'models/shared/activable'
require 'models/shared/deletable'
require 'models/shared/displayable'

module ItemResource

  extend ActiveSupport::Concern
  include Activable
  include Deletable
  include Displayable

  module ClassMethods

    def paginate(offset=nil, limit=nil)
      offset(offset || 0).limit(limit || 20)
    end

  end

  def available?
    !deleted? && active?
  end

end