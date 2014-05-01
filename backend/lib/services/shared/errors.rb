module Services
  module Errors
    extend ActiveSupport::Concern

    class BadRequest < StandardError; end
    class Unauthorized < StandardError; end
    class Forbidden < StandardError; end
    class NotFound < StandardError; end
    class Unprocessable < StandardError; end
    class TooManyRequests < StandardError; end
    class ServerError < StandardError; end
    class Unavailable < StandardError; end

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
