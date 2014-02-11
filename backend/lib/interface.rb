module ActivableScope
  extend ActiveSupport::Concern

  included do

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
  end
end

module Activable

  [:activate!, :deactivate!].each do |method|
    define_method method do
      raise "#{method} must be implemented"
    end
  end
end

module RemovableScope
  extend ActiveSupport::Concern

  included do

    scope :removed,  -> { where(removed: true) }
    scope :kept,     -> { where(removed: false) }
  end
end

module Removable

  [:delete!].each do |method|
    define_method method do
      raise "#{method} must be implemented"
    end
  end
end

module Fulfillable

  [:fulfill!, :unfulfill!].each do |method|
    define_method method do |context|
      raise "#{method} must be implemented"
    end
  end
end

module Displayable

  [:title, :description].each do |method|
    define_method method do
      raise "#{method} must be implemented"
    end
  end
end