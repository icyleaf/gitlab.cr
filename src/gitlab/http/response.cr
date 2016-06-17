require "json"
require "uri"

module Gitlab
  module HTTP
    # Http Response Class
    class Response
      @code : Int32
      @body : JSON::Any
      @method : String
      @url : URI

      enum ERROR_TYPE
        JsonError
        NonJsonError
      end

      getter :code, :body

      # Create a new Http Response
      #
      # ```
      # Gitlab::HTTP::Response.new(<HTTP::Client::Response>, "post", "http://domain.com/api/hello/world")
      # ```
      def initialize(response : ::HTTP::Client::Response, @method, @url)
        validate(response)

        @code = response.status_code
        @body = parse_body(response)
      end

      # Alias for Gitlab::HTTP::Response
      def self.parse(response, method = nil, url = nil) : HTTP::Response
        Response.new(response, method, url)
      end

      # Validate http response status code and content type
      #
      # Raise an exception if status code >= 400
      #
      # - **400**: `Error::BadRequest`
      # - **401**: `Error::Unauthorized`
      # - **403**: `Error::Forbidden`
      # - **404**: `Error::NotFound`
      # - **405**: `Error::MethodNotAllowed`
      # - **409**: `Error::Conflict`
      # - **422**: `Error::Unprocessable`
      # - **500**: `Error::InternalServerError`
      # - **502**: `Error::BadGateway`
      # - **503**: `Error::ServiceUnavailable`
      #
      # Raise an exception if content type is not json format
      #
      # - **text/html**: `Error::JSONParseError`
      def validate(response)
        case response.status_code
        when 400 then raise Error::BadRequest.new(error_message(response), response)
        when 401 then raise Error::Unauthorized.new(error_message(response), response)
        when 403 then raise Error::Forbidden.new(error_message(response), response)
        when 404 then raise Error::NotFound.new(error_message(response), response)
        when 405 then raise Error::MethodNotAllowed.new(error_message(response), response)
        when 409 then raise Error::Conflict.new(error_message(response), response)
        when 422 then raise Error::Unprocessable.new(error_message(response), response)
        when 500 then raise Error::InternalServerError.new(error_message(response), response)
        when 502 then raise Error::BadGateway.new(error_message(response), response)
        when 503 then raise Error::ServiceUnavailable.new(error_message(response), response)
        end

        raise Error::JSONParseError.new(error_message(response, ERROR_TYPE::NonJsonError), response) if response.headers["Content-Type"] == "text/html; charset=utf-8"
      end

      private def parse_body(response)
        JSON.parse(response.body)
      end

      private def error_message(response, type : ERROR_TYPE = ERROR_TYPE::JsonError)
        message = if type == ERROR_TYPE::JsonError
          response_body = parse_body(response)
          handle_error(response_body["message"] || response_body["error"])
        else
          "body is not json format. Body: #{response.body}"
        end

        "Server responded with code #{response.status_code}, " \
        "Message: #{message}. " \
        "Request URL: [#{@method}] #{@url.to_s}"
      end

      private def handle_error(message)
        case message
        when Hash
          message.to_h.sort.map do |key, val|
            "'#{key}' #{(val.is_a?(Hash) ? val.sort.map { |k, v| "(#{k}: #{v.join(' ')})" } : val).join(' ')}"
          end.join(", ")
        when Array
          message.join(" ")
        else
          message
        end
      end
    end
  end
end