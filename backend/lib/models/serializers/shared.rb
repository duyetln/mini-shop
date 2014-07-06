module ActivableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :active, :activable
  end

  def activable
    object.activable?
  end
end

module DeletableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :deleted, :deletable
  end

  def deletable
    object.deletable?
  end
end

module CommittableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :committed, :committed_at, :committable
  end

  def committable
    object.committable?
  end
end

module DisplayableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :title, :description
  end
end

module ItemableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :item_type, :item_id
    has_one :item, serializer: 'DynamicSerializer'
  end
end

module PriceableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :price_id
    has_one :price, serializer: 'PriceSerializer'
  end
end

module QuantifiableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :qty
  end
end

module ItemResourceSerializer
  extend ActiveSupport::Concern
  include ActivableSerializer
  include DeletableSerializer
  include DisplayableSerializer
end

module ItemCombinableSerializer
  extend ActiveSupport::Concern
  include ItemableSerializer
  include QuantifiableSerializer
end
