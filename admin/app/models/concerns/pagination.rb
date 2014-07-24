module Pagination
  extend ActiveSupport::Concern

  included do
    optional do
      integer :page
      integer :size
      integer :padn
    end
  end

  def pagination
    page = inputs[:page].to_i
    size = inputs[:size].to_i
    padn = inputs[:padn].to_i

    page = page >= 1 && page || 1
    size = size >= 1 && size || nil
    padn = padn >= 1 && padn || nil

    next_page = page + 1
    prev_page = page > 1 && (page - 1) || nil

    {
      page: page,
      size: size,
      padn: padn,
      next_page: next_page,
      prev_page: prev_page
    }
  end
end
