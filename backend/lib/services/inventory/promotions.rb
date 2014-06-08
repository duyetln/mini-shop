require 'services/base'
require 'services/serializers/inventory'

module Services
  module Inventory
    class Promotions < Services::Base
      get '/promotions' do
        process_request do
          promotions = Promotion.all
          respond_with(promotions.map do |promotion|
            PromotionSerializer.new(promotion)
          end)
        end
      end

      post '/promotions' do
        process_request do
          promotion = Promotion.new(params[:promotion])
          promotion.save!
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      put '/promotions/:id' do
        process_request do
          promotion = Promotion.find(params[:id])
          promotion.update_attributes!(params[:promotion])
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      put '/promotions/:id/activate' do
        process_request do
          promotion = Promotion.find(params[:id])
          promotion.activate! || unprocessable!
          respond_with(PromotionSerializer.new(promotion))
        end
      end

      delete '/promotions/:id' do
        process_request do
          promotion = Promotion.find(params[:id])
          promotion.delete! || unprocessable!
          respond_with(PromotionSerializer.new(promotion))
        end
      end
    end
  end
end
