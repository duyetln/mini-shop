require 'services/base'

module Services
  module Mailing
    class Emails < Services::Base
      post '/' do
        process_request do
          bad_request! unless email_types.include?(params[:type])
          email = constantize!(params[:type]).new(params[:payload])
          email.deliver!
          respond_with(to: email.to, date: email.date)
        end
      end

      protected

      def email_types
        %w(PurchaseReceiptEmail AccountActivationEmail PurchaseStatusEmail)
      end
    end
  end
end
