require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Batches < Services::Base
      get '/:id/coupons' do
        process_request do
          coupons = Batch.find(params[:id]).coupons
          respond_with(coupons.map do |coupon|
            CouponSerializer.new(coupon)
          end)
        end
      end

      put '/:id/activate' do
        process_request do
          batch = Batch.find(params[:id])
          batch.activate! || unprocessable!
          respond_with(BatchSerializer.new(batch))
        end
      end

      delete '/:id' do
        process_request do
          batch = Batch.find(params[:id])
          batch.delete! || unprocessable!
          respond_with(BatchSerializer.new(batch))
        end
      end
    end
  end
end
