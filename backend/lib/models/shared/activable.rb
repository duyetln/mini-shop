module Activable
  extend ActiveSupport::Concern

  included do

    attr_protected :active

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    after_initialize :set_inactive
  end

  def method_missing(method, *args, &block)
    if [
      :active,
      :active?,
      :active=
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
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
