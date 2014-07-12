require 'services/base'

module Services
  module Inventory
    class Promotions < Services::Base
      get '/' do
        process_request do
          promotions = paginate(Promotion).all
          respond_with(promotions.map do |promotion|
            PromotionSerializer.new(promotion)
          end)
        end
      end

      get '/:id' do
        process_request do
          promotion = Promotion.find(id)
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      post '/' do
        process_request do
          promotion = Promotion.new(params[:promotion])
          promotion.save!
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      put '/:id' do
        process_request do
          promotion = Promotion.find(id)
          promotion.update_attributes!(params[:promotion])
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      put '/:id/activate' do
        process_request do
          promotion = Promotion.find(id)
          promotion.activate! || unprocessable!
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      delete '/:id' do
        process_request do
          promotion = Promotion.find(id)
          promotion.delete! || unprocessable!
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      get '/:id/batches' do
        process_request do
          check_id!
          batches = paginate(Batch.joins(:promotion)
            .where(promotions: { id: id }).readonly(true)).all
          respond_with(batches.map do |batch|
            BatchSerializer.new(batch)
          end)
        end
      end

      post '/:id/batches' do
        process_request do
          batch = Promotion.find(id).create_batch(
            params[:batch][:name].to_s,
            params[:batch][:size].to_i
          )
          respond_with(BatchSerializer.new(batch))
        end
      end

      post '/:id/batches/generate' do
        process_request do
          batches = Promotion.find(id).create_batches(
            params[:qty].to_i,
            params[:batch][:size].to_i
          )
          respond_with(batches.map do |batch|
            BatchSerializer.new(batch)
          end)
        end
      end

      protected

      def check_id!
        Promotion.exists?(id) || not_found!
      end
    end
  end
end
