require 'services/base'

module Services
  module Mailing
    class Emails < Services::Base
      post '/emails' do
        process_request do
          bad_request! unless email_types.include?(params[:type])
          email = params[:type].constantize.new(params[:payload])
          email.deliver!
          respond_with(to: email.to, date: email.date)
        end
      end

      protected

      def email_types
        [
          'PurchaseReceiptEmail',
          'AccountActivationEmail',
          'PurchaseStatusEmail'
        ]
      end
    end
  end
end
