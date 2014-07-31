module BackendClient
  class Coupon
    include APIResource
    include APIModel
    include DefaultFind

    def self.build_attributes(hash = {})
      super do |coupon|
        coupon.used_at = DateTime.parse(coupon.used_at) if coupon.used_at.present?
      end
    end

    def promotion
      Promotion.find(promotion_id)
    end
  end
end
