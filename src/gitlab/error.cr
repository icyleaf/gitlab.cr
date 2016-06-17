require "json"

module Gitlab
  module Error
    class Error < Exception; end

    ## Client Errors

    class NotMatchTypeError < Error; end
    class NotAllowRequestMethodError < Error; end

    ## Gitlab API Errors

    class APIError < Error
      def initialize(@message : String? = nil, @response : ::HTTP::Client::Response? = nil)
        super(@message)
      end
    end

    class JSONParseError < APIError; end
    class MissingCredentials < APIError; end
    class BadRequest < APIError; end
    class Unauthorized < APIError; end
    class Forbidden < APIError; end
    class NotFound < APIError; end
    class MethodNotAllowed < APIError; end
    class Conflict < APIError; end
    class Unprocessable < APIError; end
    class InternalServerError < APIError; end
    class BadGateway < APIError; end
    class ServiceUnavailable < APIError; end
  end
end