module Fulfillable
  extend ActiveSupport::Concern

  def method_missing(method, *args, &block)
    if [
      :fulfill!,
      :reverse!
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end
end
