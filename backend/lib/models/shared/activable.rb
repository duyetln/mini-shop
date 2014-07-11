=begin
dependencies: must have 'active' column
interface methods:
  active
  active=
  active?
  inactive?
  activable?
  activate!
  active scope
  inactive scope
=end

module Activable
  extend ActiveSupport::Concern

  included do
    attr_protected :active

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    after_initialize :set_inactive
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
    active?
  end

  protected

  def set_inactive
    if new_record?
      self.active = false
    end
  end
end
