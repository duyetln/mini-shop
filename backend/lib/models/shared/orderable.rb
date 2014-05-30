require 'models/shared/fulfillable'

module Orderable
  extend ActiveSupport::Concern
  include Fulfillable

  def method_missing(method, *args, &block)
    if [
      :item,
      :amount
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end
end
