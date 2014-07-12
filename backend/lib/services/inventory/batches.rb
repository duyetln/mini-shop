require 'services/base'

module Services
  module Inventory
    class Batches < Services::Base
      get '/:id/coupons' do
        process_request do
          check_id!
          coupons = paginate(Coupon.joins(:batch)
            .where(batches: { id: id }).readonly(true)).all
          respond_with(coupons.map do |coupon|
            CouponSerializer.new(coupon)
          end)
        end
      end

      post '/:id/coupons/generate' do
        process_request do
          batch = Batch.find(id)
          batch.create_coupons(params[:qty].to_i)
          respond_with(BatchSerializer.new(batch))
        end
      end

      put '/:id' do
        process_request do
          batch = Batch.find(id)
          batch.update_attributes!(params[:batch])
          respond_with(BatchSerializer.new(batch))
        end
      end

      put '/:id/activate' do
        process_request do
          batch = Batch.find(id)
          batch.activate! || unprocessable!
          respond_with(BatchSerializer.new(batch))
        end
      end

      delete '/:id' do
        process_request do
          batch = Batch.find(id)
          batch.delete! || unprocessable!
          respond_with(BatchSerializer.new(batch))
        end
      end

      protected

      def check_id!
        Batch.exists?(id) || not_found!
      end
    end
  end
end
