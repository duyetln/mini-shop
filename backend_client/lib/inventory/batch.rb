require 'lib/base'

module BackendClient
  class Batch < Base
    extend DefaultFind
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def coupons(pagination = {})
      self.class.parse(
        self.class.resource["/#{id}/coupons"].get params: pagination.slice(:page, :size, :padn)
      ).map do |hash|
        Coupon.instantiate(hash)
      end
    end

    def create_coupons(qty)
      self.class.parse(
        self.class.resource["/#{id}/coupons/generate"].post qty: qty
      ) do |hash|
        load!(hash)
      end
    end
  end
end
