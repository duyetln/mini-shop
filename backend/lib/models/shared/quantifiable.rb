module Quantifiable
  extend ActiveSupport::Concern

  included do
    validates :qty, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 }
  end

  def method_missing(method, *args, &block)
    if [
      :qty,
      :qty=
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end
end
