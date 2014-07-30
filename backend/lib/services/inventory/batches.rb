require 'services/base'

module Services
  module Inventory
    class Batches < Services::Base
      get '/:id' do
        batch = Batch.find(id)
        respond_with(BatchSerializer.new(batch))
      end

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
        batch.activate! || unprocessable!(
          message: 'Unable to activate batch',
          meta: 'The batch is not activable or not ready for activation'
        )
        respond_with(BatchSerializer.new(batch))
      end

      delete '/:id' do
        batch = Batch.find(id)
        batch.delete! || unprocessable!(
          message: 'Unable to delete batch',
          meta: 'The batch is not deletable or not allowed for deletion'
        )
        respond_with(BatchSerializer.new(batch))
      end

      protected

      def check_id!
        Batch.exists?(id) || not_found!(meta: 'Batch id is not valid')
      end
    end
  end
end
