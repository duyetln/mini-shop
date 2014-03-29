module Activable
  extend ActiveSupport::Concern

  included do

    attr_protected :active

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    default_scope { active }
  end

  [:active, :active?].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (raise NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  [:active=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (raise NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  def inactive?
    !active?
  end

  def activate!
    if inactive?
      self.active = true
      save!
    end
  end

  def deactivate!
    if active?
      self.active = false
      save!
    end
  end
end
