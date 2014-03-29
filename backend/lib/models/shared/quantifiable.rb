module Quantifiable
  extend ActiveSupport::Concern

  included do

    validates :qty, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 }
  end

  [:qty].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (raise NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  [:qty=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (raise NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end
end
