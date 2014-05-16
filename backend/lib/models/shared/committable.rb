module Committable
  extend ActiveSupport::Concern

  included do

    attr_protected :committed, :committed_at

    scope :committed, -> { where(committed: true) }
    scope :pending,   -> { where(committed: false) }

    after_initialize :set_pending
  end

  [:committed=, :committed_at=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  [:commtted, :committed_at, :committed?].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  def pending?
    !committed?
  end

  def commit!
    if pending?
      self.committed    = true
      self.committed_at = DateTime.now
      save!
    end
  end

  protected

  def set_pending
    if new_record?
      self.committed    = false
      self.committed_at = nil
    end
  end
end
