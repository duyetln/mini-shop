require 'services/base'

module Services
  module Inventory
    class Batches < Services::Base
      get '/:id/coupons' do
        check_id!
        coupons = paginate(Coupon.joins(:batch)
          .where(batches: { id: id }).readonly(true)).all
        respond_with(coupons.map do |coupon|
          CouponSerializer.new(coupon)
        end)
      end

      post '/:id/coupons/generate' do
        batch = Batch.find(id)
        batch.create_coupons(params[:qty].to_i)
        respond_with(BatchSerializer.new(batch))
      end

      put '/:id' do
        batch = Batch.find(id)
        batch.update_attributes!(params[:batch])
        respond_with(BatchSerializer.new(batch))
      end

      put '/:id/activate' do
        batch = Batch.find(id)
        batch.activate! || unprocessable!('Unable to activate batch')
        respond_with(BatchSerializer.new(batch))
      end

      delete '/:id' do
        batch = Batch.find(id)
        batch.delete! || unprocessable!('Unable to delete batch')
        respond_with(BatchSerializer.new(batch))
      end

      protected

      def check_id!
        Batch.exists?(id) || not_found!
      end
    end
  end
end
