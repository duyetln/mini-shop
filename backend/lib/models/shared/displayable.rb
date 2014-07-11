=begin
dependencies: none
interface methods:
  title
  description
=end

module Displayable
  extend ActiveSupport::Concern

  included do
    validates :title, presence: true
  end

  def method_missing(method, *args, &block)
    if [
      :title,
      :description
    ].include?(method.to_sym)
      fail NotImplementedError, "Method #{method} must be defined in derived class"
    else
      super
    end
  end
end
