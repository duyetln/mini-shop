module BackendClient
  class Coupon < APIModel
    def self.build_attributes(hash = {})
      super do |coupon|
        coupon.used_at = DateTime.parse(coupon.used_at) if coupon.used_at.present?
      end
    end

    def self.find_by_code(code)
      new(get path: "/#{code}")
    end

    def promotion
      Promotion.find(promotion_id)
    end
  end
end
