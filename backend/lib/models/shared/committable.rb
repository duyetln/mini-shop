=begin
dependencies: must have 'committed', 'committed_at' columns
interface methods:
  committed
  committed=
  committed_at
  committed_at=
  committed?
  pending?
  committable?
  commit!
  committed scope
  pending scope
=end

module Committable
  extend ActiveSupport::Concern

  included do
    attr_protected :committed, :committed_at

    scope :committed, -> { where(committed: true) }
    scope :pending,   -> { where(committed: false) }

    after_initialize :set_pending
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
