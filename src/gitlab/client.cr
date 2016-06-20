require "./client/**"

module Gitlab
  # Gitlab API Client wrapper
  #
  # See the [Gitlab Offical API Document](http://docs.gitlab.com/ce/api/README.html) for more details.
  class Client
    getter :endpoint, :token

    enum ErrorType
      JsonError
      NonJsonError
    end

    # Create a new client
    #
    # ```
    # Gitlab.Client.new("<endpoint>", "<token")
    # ```
    def initialize(@endpoint : String, @token : String)
    end

    {% for method in [:get, :post, :put, :delete] %}
      # Return a Gitlab::Response by sending a {{method.id.upcase}} method http request
      #
      # ```
      # client.{{method.id}}("/path", { "key" => "value"})
      # ```
      def {{method.id}}(uri : String, params : Hash? = nil) : HTTP::Response
        request({{method}}, uri, params)
      end
    {% end %}

    # Return a `Gitlab::Response` by sending the target http request
    #
    # ```
    # client.request({{method}}, "/path", { "key" => "value"})
    # ```
    def request(method, uri, params : Hash? = nil) : HTTP::Response
      response = HTTP.request(method, build_url(uri), default_options(uri, params))
      validate(response)

      response
    end

    # Return a full url string from built with base domain and url path
    private def build_url(uri)
      File.join(@endpoint, uri)
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
    private def validate(response : HTTP::Response)
      raise Error::JSONParseError.new(error_message(response, ErrorType::NonJsonError), response) if response.content_type == HTTP::Response::ContentType::HTML

      case response.code
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
    end

    # Output error message
    private def error_message(response, type : ErrorType = ErrorType::JsonError)
      message = if type == ErrorType::JsonError
        response_body = response.body.parse_json
        handle_error(response_body["message"] || response_body["error"])
      else
        "body is not json format. Body: #{response.body}"
      end

      "Server responded with code #{response.code}, " \
      "Message: #{message}. " \
      "Request URL: [#{response.method}] #{response.url.to_s}"
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

    # Sets headers and query params for requests
    private def default_options(url, params : Hash? = nil)
      Hash(String, Hash(String, String)).new.tap do |hash|
        hash["headers"] = default_headers unless url.includes?("/session")
        hash["params"] = params if params
      end
    end

    # Set a default Auth(PRIVATE-TOKEN or Authorization) header
    #
    # Raise an `Error::MissingCredentials` exception if token is not set.
    private def default_headers
      error_message = "Please provide a private_token or auth_token for user"
      raise Error::MissingCredentials.new(error_message) unless @token

      if @token.size <= 20
        {"PRIVATE-TOKEN" => @token}
      else
        {"Authorization" => "Bearer #{@token}"}
      end
    end

    include User
    include Session
    include Group
    include Project
    include Repository
    include Branch
    include Tag
    include Issue
    include Commit
    include Note
    include Key
  end
end
