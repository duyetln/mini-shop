module Services
  module Errors
    extend ActiveSupport::Concern

    class Base < StandardError; end
    class BadRequest < Base; end
    class Unauthorized < Base; end
    class Forbidden < Base; end
    class NotFound < Base; end
    class Unprocessable < Base; end
    class TooManyRequests < Base; end
    class ServerError < Base; end
    class Unavailable < Base; end

    included do
      {
        BadRequest => 400,
        Unauthorized => 401,
        Forbidden => 403,
        NotFound => 404,
        Unprocessable => 422,
        TooManyRequests => 429,
        ServerError => 500,
        Unavailable => 503
      }.each do |type, code|
        error type do
          status code
          respond_with message: env['sinatra.error'].message
        end

        define_method "#{type.name.demodulize.underscore}!" do |message = nil|
          fail type, message
        end
      end
    end
  end
end
