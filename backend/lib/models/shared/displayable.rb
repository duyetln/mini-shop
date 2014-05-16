module Displayable
  extend ActiveSupport::Concern

  included do

    validates :title, presence: true
  end

  [:title, :description].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end
end
