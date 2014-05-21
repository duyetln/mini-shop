require 'models/shared/fulfillable'

module Orderable
  extend ActiveSupport::Concern
  include Fulfillable

  [:item, :amount].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end
end
