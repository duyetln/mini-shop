module Itemable
  
  extend ActiveSupport::Concern

  included do

    attr_readonly :item_type, :item_id

    belongs_to :item, polymorphic: true

    validates :item, presence: true
  end

  [:item, :item_type, :item_id].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise NotImplementedError, "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  [:item=, :item_type=, :item_id=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise NotImplementedError, "#{__method__} must be defined in derived class" )
      end
    EOF
  end

end