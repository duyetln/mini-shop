module BackendClient
  class Batch < APIModel
    include DefaultFind
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def coupons(pagination = {})
      self.class.get(
        path: "/#{id}/coupons",
        payload: pagination.slice(:page, :size, :padn)
      ).map do |hash|
        Coupon.new(hash)
      end
    end

    def create_coupons(qty)
      load!(
        self.class.post(
          path: "/#{id}/coupons/generate",
          payload: { qty: qty }
        )
      )
    end
  end
end
