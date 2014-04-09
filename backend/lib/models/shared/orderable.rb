module Orderable
  extend ActiveSupport::Concern

  [:prepare!, :amount].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (raise NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end
end
