module Displayable

  extend ActiveSupport::Concern

  [:title, :description].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  [:title=, :description=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

end