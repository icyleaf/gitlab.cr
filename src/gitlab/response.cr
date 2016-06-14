require "json"

module Gitlab
  class Response
    @code : Int32
    @body : JSON::Any
    @method : String
    @url : String

    getter :code, :body

    def initialize(response : HTTP::Client::Response, @method = nil, @url = nil)
      validate(response)

      @code = response.status_code
      @body = parse_body(response)
    end

    def self.parse(response)
      Response.new(response)
    end

    private def validate(response)
      case response.status_code
      when 400 then raise Error::BadRequest.new error_message(response)
      when 401 then raise Error::Unauthorized.new error_message(response)
      when 403 then raise Error::Forbidden.new error_message(response)
      when 404 then raise Error::NotFound.new error_message(response)
      when 405 then raise Error::MethodNotAllowed.new error_message(response)
      when 409 then raise Error::Conflict.new error_message(response)
      when 422 then raise Error::Unprocessable.new error_message(response)
      when 500 then raise Error::InternalServerError.new error_message(response)
      when 502 then raise Error::BadGateway.new error_message(response)
      when 503 then raise Error::ServiceUnavailable.new error_message(response)
      end
    end

    private def parse_body(response)
      JSON.parse(response.body)
    end

    private def error_message(response)
      response_body = parse_body(response)
      message = response_body["message"] || response_body["error"]

      "Server responded with code #{response.status_code}, " \
      "message: handle_error(#{message}). " \
      "Request URL: [#{@method}] #{@url}"
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