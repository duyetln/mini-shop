module Pageable
  extend ActiveSupport::Concern

  module ClassMethods
    def page(page = nil, opts = {})
      page = page.to_i
      size = opts[:size].to_i
      padn = opts[:padn].to_i

      if page > 0
        size =  size > 0 && size || 25
        padn =  padn > 0 && padn || 0
        offs = (page - 1) * size
        offset(offs).limit(size + padn)
      else
        scoped
      end
    end
  end
end

ActiveRecord::Base.include Pageable
