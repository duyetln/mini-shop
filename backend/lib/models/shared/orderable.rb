module Orderable

  extend ActiveSupport::Concern

  [:item].each do |method|
    class_eval <<-EOF
      def #{method}
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  [:amount].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end
end