require 'models/shared/fulfillable'

=begin
dependencies: Fulfillable
interface methods:
  item
  amount
  active?
  available?
=end

module Orderable
  extend ActiveSupport::Concern
  include Fulfillable

  def method_missing(method, *args, &block)
    if [
      :item,
      :amount,
      :active?,
      :available?
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end
end
