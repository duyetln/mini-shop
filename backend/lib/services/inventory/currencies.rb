require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Currencies < Services::Base
      get '/currencies' do
        process_request do
          currencies = Currency.all
          respond_with(currencies.map do |currency|
            CurrencySerializer.new(currency)
          end)
        end
      end

      post '/currencies' do
        process_request do
          currency = Currency.new(params[:currency])
          currency.save!
          respond_with(CurrencySerializer.new(currency))
        end
      end
    end
  end
end
