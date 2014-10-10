module BackendClient
  class RequestError < StandardError; end
  class APIError < StandardError
    attr_reader :meta
    attr_reader :code
    def initialize(restclient_error)
      payload = Yajl::Parser.parse(
        restclient_error.http_body,
        symbolize_keys: true
      )
      @code = restclient_error.http_code
      @meta = payload[:meta]
      super(payload[:message])
    end
  end

  class ClientError < APIError; end
  class BackendError < APIError; end

  class BadRequest < ClientError; end
  class Unauthorized < ClientError; end
  class Forbidden < ClientError; end
  class NotFound < ClientError; end
  class Unprocessable < ClientError; end
  class TooManyRequest < ClientError; end
  class ServerError < BackendError; end
  class Unavailable < BackendError; end

  module Errors
    extend ActiveSupport::Concern

    module ClassMethods
      protected

      def handle_error
        yield
      rescue RestClient::ExceptionWithResponse => e
        case e.http_code
        when  400       then raise BackendClient::BadRequest.new(e)
        when  401       then raise BackendClient::Unauthorized.new(e)
        when  403       then raise BackendClient::Forbidden.new(e)
        when  404       then raise BackendClient::NotFound.new(e)
        when  422       then raise BackendClient::Unprocessable.new(e)
        when (400..499) then raise BackendClient::ClientError.new(e)
        when  500       then raise BackendClient::ServerError.new(e)
        when  503       then raise BackendClient::Unavailable.new(e)
        when (500..599) then raise BackendClient::BackendError.new(e)
        else                 raise BackendClient::APIError.new(e)
        end
      rescue RestClient::Exception, Errno::ECONNREFUSED => e
        raise BackendClient::RequestError, e.message
      end
    end
  end
end
