require 'services/base'

module Services
  module Inventory
    class Promotions < Services::Base
      get '/' do
        promotions = paginate(Promotion).all
        respond_with(promotions.map do |promotion|
          PromotionSerializer.new(promotion)
        end)
      end

      get '/:id' do
        promotion = Promotion.find(id)
        respond_with(PromotionSerializer.new(promotion))
      end

      post '/' do
        promotion = Promotion.new(params[:promotion])
        promotion.save!
        respond_with(PromotionSerializer.new(promotion))
      end

      put '/:id' do
        promotion = Promotion.find(id)
        promotion.update_attributes!(params[:promotion])
        respond_with(PromotionSerializer.new(promotion))
      end

      put '/:id/activate' do
        promotion = Promotion.find(id)
        promotion.activate! || unprocessable!(
          message: 'Unable to activate promotion',
          meta: 'The promotion is not activable or not ready for activation'
        )
        respond_with(PromotionSerializer.new(promotion))
      end

      delete '/:id' do
        promotion = Promotion.find(id)
        promotion.delete! || unprocessable!(
          message: 'Unable to delete promotion',
          meta: 'The promotion is not deletable or not allowed for deletion'
        )
        respond_with(PromotionSerializer.new(promotion))
      end

      get '/:id/batches' do
        promotion = Promotion.find(id)
        batches = paginate(promotion.batches).all
        respond_with(batches.map do |batch|
          BatchSerializer.new(batch)
        end)
      end

      post '/:id/batches' do
        batch = Promotion.find(id).create_batch(
          params[:batch][:name].to_s,
          params[:batch][:size].to_i
        )
        respond_with(BatchSerializer.new(batch))
      end

      post '/:id/batches/generate' do
        batches = Promotion.find(id).create_batches(
          params[:qty].to_i,
          params[:batch][:size].to_i
        )
        respond_with(batches.map do |batch|
          BatchSerializer.new(batch)
        end)
      end
    end
  end
end
