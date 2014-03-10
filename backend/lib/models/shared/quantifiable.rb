module Quantifiable

  extend ActiveSupport::Concern

  included do

    attr_accessible :quantity

    validates :quantity, presence: true
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  end

  [:quantity].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise NotImplementedError, "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  [:quantity=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise NotImplementedError, "#{__method__} must be defined in derived class" )
      end
    EOF
  end
  
end