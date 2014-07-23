module Services
  module Errors
    extend ActiveSupport::Concern

    included do
      {
        :bad_request        => 400,
        :unauthorized       => 401,
        :forbidden          => 403,
        :not_found          => 404,
        :unprocessable      => 422,
        :too_many_requests  => 429,
        :server_error       => 500,
        :unavailable        => 503
      }.each do |type, code|
        define_method "#{type}!" do |message = type.to_s.humanize|
          content_type 'application/json'
          halt code, { message: message }.to_json
        end
      end

      error ActiveRecord::UnknownAttributeError do
        bad_request! env['sinatra.error'].message.capitalize
      end

      error ActiveRecord::RecordNotFound do
        not_found! 'Resource requested not found'
      end

      error ActiveRecord::RecordInvalid do
        bad_request! env['sinatra.error'].message.capitalize
      end

      error StandardError do
        server_error!
      end
    end
  end
end
