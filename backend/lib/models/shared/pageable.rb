module Pageable
  extend ActiveSupport::Concern

  module ClassMethods
    def page(page = nil, options = {})
      if page.present? && page.to_i > 0
        limit = options[:size].to_i || 25
        padding = options[:padding].to_i || 0
        offset = (page - 1) * limit
        offset(offset).limit(limit + padding)
      else
        scoped
      end
    end
  end
end

ActiveRecord::Base.include Pageable
