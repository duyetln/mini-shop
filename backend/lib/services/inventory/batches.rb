require 'services/base'

module Services
  module Inventory
    class Batches < Services::Base
      get '/:id' do
        batch = Batch.find(id)
        respond_with(BatchSerializer.new(batch))
      end

      get '/:id/coupons' do
        batch = Batch.find(id)
        coupons = paginate(batch.coupons).all
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
    end
  end
end
