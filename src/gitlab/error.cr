module Gitlab
  module Error
    class Error < Exception; end

    # # Client Errors

    class NoSupportGraphQLAPIError < Exception; end

    class NotExistsFileError < Error; end

    class NotMatchTypeError < Error; end

    class NotAllowRequestMethodError < Error; end

    class MissingCredentials < Error; end

    # # Gitlab API Errors

    class APIError < Error
      getter response

      def initialize(@response : Halite::Response)
        super(build_error_message)
      end

      private def build_error_message
        message = case @response.content_type
                  when Nil
                    "#{response.body[0..50]}..."
                  when .includes?("json")
                    response_body = response.parse
                    handle_error(response_body["message"]? || response_body["error"]?)
                  when .includes?("text")
                    response.body
                  else
                    "#{response.body[0..50]}..."
                  end

        "Server responded with code #{response.status_code}, message: " \
        "#{message}. " \
        "Request URI: #{response.uri.to_s}"
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
