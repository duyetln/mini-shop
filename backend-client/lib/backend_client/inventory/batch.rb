require 'backend_client/base'

module BackendClient
  class Batch < Base
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def coupons
      self.class.parse(
        self.class.resource["/#{id}/coupons"].get
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
