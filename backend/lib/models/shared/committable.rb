module Committable

  extend ActiveSupport::Concern

  included do

    scope :committed, -> { where(committed: true) }
    scope :pending,   -> { where(committed: false) }
  end

  [:committed=, :committed_at=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  [:commtted, :committed_at, :committed?].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  def pending?
    !committed?
  end

  def commit!
    if persisted? && pending?
      self.committed    = true
      self.committed_at = DateTime.now
      save!
    end
  end

end