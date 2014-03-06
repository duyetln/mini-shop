module Deletable

  extend ActiveSupport::Concern

  included do

    scope :deleted, -> { where(deleted: true) }
    scope :kept,    -> { where(deleted: false) }
  end

  [:deleted, :deleted?].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  [:deleted=].each do |method|
    class_eval <<-EOF
      def #{method}(*args)
        defined?(super) ? super : ( raise "#{__method__} must be defined in derived class" )
      end
    EOF
  end

  def kept?
    !deleted?
  end

  def delete!
    if persisted? && !deleted?
      self.deleted = true
      save!
    end
  end

end