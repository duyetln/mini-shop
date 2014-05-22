module Deletable
  extend ActiveSupport::Concern

  included do

    attr_protected :deleted

    scope :deleted, -> { where(deleted: true) }
    scope :kept,    -> { where(deleted: false) }

    default_scope { kept }
  end

  def method_missing(method, *args, &block)
    if [
      :deleted,
      :deleted?,
      :deleted=
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
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
    deleted?
  end
end
