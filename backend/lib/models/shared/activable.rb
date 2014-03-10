module Activable

  extend ActiveSupport::Concern

  included do

    scope :active,   -> { where(active: true) }
    scope :inactive, -> { where(active: false) }

    after_initialize :set_active
  end

  [:active, :active?].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  [:active=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  def inactive?
    !active?
  end

  def activate!
    if persisted? && inactive?
      self.active = true
      save!
    end
  end

  def deactivate!
    if persisted? && active?
      self.active = false
      save!
    end
  end

  protected

  def set_active
    if new_record?
      self.active = true
    end
  end

end