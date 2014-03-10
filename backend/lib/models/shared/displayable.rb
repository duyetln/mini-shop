module Displayable

  extend ActiveSupport::Concern

  included do

    attr_accessible :title, :description  if ( [:title, :description] - self.column_names.map(&:to_sym) ).blank?

    validates :title, presence: true
  end

  [:title, :description].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

end