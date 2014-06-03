module Itemable
  extend ActiveSupport::Concern

  included do
    attr_readonly :item_type, :item_id

    belongs_to :item, polymorphic: true

    validates :item, presence: true
  end

  def method_missing(method, *args, &block)
    if [
      :item,
      :item=,
      :item_type,
      :item_type=,
      :item_id,
      :item_id=
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end
end
