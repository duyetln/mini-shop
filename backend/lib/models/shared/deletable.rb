module Deletable
  extend ActiveSupport::Concern

  included do

    attr_protected :deleted

    scope :deleted, -> { where(deleted: true) }
    scope :kept,    -> { where(deleted: false) }

    default_scope { kept }
  end

  [:deleted, :deleted?].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  [:deleted=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : (fail NotImplementedError, "#{__method__} must be defined in derived class")
      end
    EOF
  end

  def kept?
    !deleted?
  end

  def deletable?
    kept?
  end

  def delete!
    if deletable?
      self.deleted = true
      save!
    end
  end
end
