require 'lib/base'

module BackendClient
  class Coupon < Base
    def self.instantiate(hash = {})
      super do |coupon|
        coupon.used_at = DateTime.parse(coupon.used_at) if coupon.used_at.present?
      end
    end

    def self.find_by_code(code)
      catch_error RestClient::ResourceNotFound do
        fail BackendClient::Errors::NotFound.new(
          "Unable to find #{humanized_name}",
          'Code is invalid'
        )
      end
      handle_error do
        parse(resource["/#{code}"].get) do |hash|
          instantiate(hash)
        end
      end
    end

    def promotion
      Promotion.find(promotion_id)
    end
  end
end
