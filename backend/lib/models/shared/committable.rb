module Committable
  extend ActiveSupport::Concern

  included do

    attr_protected :committed, :committed_at

    scope :committed, -> { where(committed: true) }
    scope :pending,   -> { where(committed: false) }

    after_initialize :set_pending
  end

  def method_missing(method, *args, &block)
    if [
      :committed=,
      :committed_at=,
      :committed,
      :committed_at,
      :committed
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end

  def pending?
    !committed?
  end

  def committable?
    pending?
  end

  def commit!
    if committable?
      self.committed    = true
      self.committed_at = DateTime.now
      save!
    end
    committed?
  end

  protected

  def set_pending
    if new_record?
      self.committed    = false
      self.committed_at = nil
    end
  end
end
