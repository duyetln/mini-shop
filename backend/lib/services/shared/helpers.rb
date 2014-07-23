module Services
  module Helpers
    protected

    def paginate(scope)
      scope.page(params[:page],
                 size: params[:size],
                 padn: params[:padn]
      )
    end

    def id
      params[:id]
    end

    def constantize!(string)
      begin
        string.classify.constantize
      rescue NameError => ex
        bad_request! "Invalid type #{ex.missing_name}"
      end
    end

    def process_request
      yield
    rescue ::Services::Errors::Base
      raise
    rescue ActiveRecord::RecordNotFound => ex
      fail ::Services::Errors::NotFound, ex.message
    rescue ActiveRecord::RecordInvalid => ex
      fail ::Services::Errors::BadRequest, ex.message
    rescue => ex
      fail ::Services::Errors::ServerError, ex.message
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
