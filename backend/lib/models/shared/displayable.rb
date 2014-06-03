module Displayable
  extend ActiveSupport::Concern

  included do
    validates :title, presence: true
  end

  def method_missing(method, *args, &block)
    if [
      :title,
      :description
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end

  [:title, :description].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end
end
