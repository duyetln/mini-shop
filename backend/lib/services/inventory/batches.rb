require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Batches < Services::Base
      get '/promotions/:id/batches' do
        process_request do
          batches = Promotion.find(params[:id]).batches
          respond_with(batches.map do |batch|
            BatchSerializer.new(batch)
          end)
        end
      end

      post '/promotions/:id/batches' do
        process_request do
          batch = Promotion.find(params[:id]).create_batch(
            params[:batch][:size].to_i,
            params[:batch][:name].to_s
          )
          respond_with(BatchSerializer.new(batch))
        end
      end

      post '/promotions/:id/batches/generate' do
        process_request do
          batches = Promotion.find(params[:id]).create_batches(
            params[:qty].to_i,
            params[:batch][:size].to_i,
            params[:batch][:name].to_s
          )
          respond_with(batches.map do |batch|
            BatchSerializer.new(batch)
          end)
        end
      end

      get '/batches/:id/coupons' do
        process_request do
          coupons = Batch.find(params[:id]).coupons
          respond_with(coupons.map do |coupon|
            CouponSerializer.new(coupon)
          end)
        end
      end

      put '/batches/:id/activate' do
        process_request do
          batch = Batch.find(params[:id])
          batch.activate! || unprocessable!
          respond_with(BatchSerializer.new(batch))
        end
      end

      delete '/batches/:id' do
        process_request do
          batch = Batch.find(params[:id])
          batch.delete! || unprocessable!
          respond_with(BatchSerializer.new(batch))
        end
      end
    end
  end
end
