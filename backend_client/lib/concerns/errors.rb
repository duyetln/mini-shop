module BackendClient
  module Errors
    class Base < StandardError
      attr_reader :description
      def initialize(message, description = nil)
        @description = description
        super(message)
      end
    end
    class BadRequest < Base; end
    class Unauthorized < Base; end
    class Forbidden < Base; end
    class NotFound < Base; end
    class Unprocessable < Base; end
    class TooManyRequest < Base; end
    class ServerError < Base; end
    class Unavailable < Base; end

    module Handlers
      extend ActiveSupport::Concern

      included do
        protected :catch_error, :handle_error
      end

      def catch_error(*error_classes, &block)
        error_classes.each do |klass|
          if klass.present? &&
            klass < StandardError &&
            block_given?
            @error_handlers ||= {}
            @error_handlers[klass] = block
          end
        end
      end

      def handle_error(reset_handlers = true)
        yield if block_given?
      rescue => error
        @error_handlers ||= {}
        @error = error
        block = @error_handlers[@error.class]
        if block.present?
          instance_eval &block
        else
          raise
        end
      ensure
        @error = nil
        if reset_handlers
          @error_handlers = {}
        end
      end
    end
  end
end
