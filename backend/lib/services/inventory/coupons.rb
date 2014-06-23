require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Coupons < Services::Base
      get '/:code' do
        process_request do
          coupon = Coupon.find_by_code!(params[:code])
          not_found! if coupon.deleted?
          respond_with(CouponSerializer.new(coupon))
        end
      end
    end
  end
end
