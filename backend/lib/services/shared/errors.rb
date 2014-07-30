module Services
  module Errors
    extend ActiveSupport::Concern

    included do
      {
        :bad_request        => [400, 'Request does not provide valid parameters'],
        :unauthorized       => [401, 'Request does not provide valid authorization credentials'],
        :forbidden          => [403, 'Request does not have sufficient permission or access'],
        :not_found          => [404, 'Request does not provide valid identifiers or tries to fetch deleted resources'],
        :unprocessable      => [422, 'Request attempts to modify affected resources in invalid state'],
        :too_many_requests  => [429, 'Request is rate limited'],
        :server_error       => [500, 'Unexpected server error has occurred'],
        :unavailable        => [503, 'Service is temporarily unavailable']
      }.each do |type, defaults|
        define_method "#{type}!" do |opts = {}|
          payload = { message: defaults.last, meta: "" }.merge(opts.slice(:message, :meta))
          content_type 'application/json'
          halt defaults.first, payload.to_json
        end
      end

      error ActiveRecord::UnknownAttributeError do
        bad_request! meta: env['sinatra.error'].message.capitalize
      end

      error ActiveRecord::RecordNotFound do
        not_found!
      end

      error ActiveRecord::RecordInvalid do
        bad_request! meta: env['sinatra.error'].message.capitalize
      end

      error StandardError do
        server_error!
      end
    end
  end
end
