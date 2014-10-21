module BackendClient
  class Batch
    include APIResource
    include APIModel
    include DefaultFind
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def promotion
      @cache[:promotion] ||= Promotion.find(promotion_id)
    end

    def coupons(pagination = {})
      self.class.get(
        path: "/#{id}/coupons",
        payload: pagination.slice(:page, :size, :padn, :sort)
      ).map do |hash|
        Coupon.instantiate(hash)
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
