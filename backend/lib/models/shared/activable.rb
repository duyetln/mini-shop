module Activable
  extend ActiveSupport::Concern

  included do

    attr_protected :active

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    after_initialize :set_inactive
  end

  [:active, :active?].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  [:active=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  def inactive?
    !active?
  end

  def activable?
    inactive?
  end

  def activate!
    if activable?
      self.active = true
      save!
    end
  end

  protected

  def set_inactive
    if new_record?
      self.active = false
    end
  end
end
