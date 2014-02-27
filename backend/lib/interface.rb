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

module DeletableScope
  extend ActiveSupport::Concern

  included do

    scope :deleted,  -> { where(deleted: true) }
    scope :kept,     -> { where(deleted: false) }
  end
end

module Deletable

  [:delete!].each do |method|
    define_method method do
      raise "#{method} must be implemented"
    end
  end
end

module CommittableScope
  extend ActiveSupport::Concern

  included do

    scope :committed, -> { where(committed: true) }
    scope :pending,   -> { where(committed: false) }
  end
end

module Committable

  [:commit!].each do |method|
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

