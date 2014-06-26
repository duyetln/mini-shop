class Coupon < ServiceResource
  def self.instantiate(hash = {})
    super do |coupon|
      coupon.used_at = DateTime.parse(coupon.used_at) if coupon.used_at.present?
    end
  end
end
