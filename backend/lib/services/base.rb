module Services
  class Base < Sinatra::Base
    register Sinatra::RespondTo

    configure do
      set :default_content, :json
      disable :show_exceptions
      disable :raise_errors
    end

    error ActiveRecord::RecordNotFound do
      status 404
      respond_with message: exception.message
    end

    error ActiveRecord::RecordInvalid do
      status 400
      respond_with messages: exception.message, errors: exception.record.errors
    end

    not_found do
      respond_with message: 'Resource Not Found'
    end

    error do
      respond_with message: exception.message
    end

    helpers do

      protected

      def exception
        env['sinatra.error']
      end

      def invalid_request
        error 400, message: 'Invalid Request'
      end

      def respond_with(body)
        yield body if block_given?
        respond_to do |format|
          format.js { body.to_json }
          format.json { body.to_json }
          format.xml { 'XML Representation Not Supported' }
          format.html { 'HTML Representation Not Supported' }
        end
      end
    end
  end
end