require "./client/**"
require "halite"
require "json"

module Gitlab
  # Gitlab API Client wrapper
  #
  # See the [Gitlab Offical API Document](http://docs.gitlab.com/ce/api/README.html) for more details.
  class Client
    # The endpoint of Gitlab
    property endpoint

    # The token(private-token or OAuth2 access token) of Gitlab
    property token

    # :nodoc:
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
      raise Gitlab::Error::NoSupportGraphQLAPIError.new("Sorry, No support for GraphQL API(v4)") if @endpoint.includes?("api/v4")
    end

    {% for verb in %w(get head) %}
      # Return a Gitlab::Response by sending a {{verb.id.upcase}} method http request
      #
      # ```
      # client.{{ verb.id }}("/path", params: {
      #   first_name: "foo",
      #   last_name:  "bar"
      # })
      # ```
      def {{ verb.id }}(uri : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
        headers = headers ? default_headers.merge(headers) : default_headers
        response = Halite.{{verb.id}}(build_url(uri), headers: headers, params: params)
        validate(response)
        response
      end
    {% end %}

    {% for verb in %w(post put patch delete) %}
      # Return a `Gitlab::Response` by sending a {{verb.id.upcase}} http request
      #
      # ```
      # client.{{ verb.id }}("/path", form: {
      #   first_name: "foo",
      #   last_name:  "bar"
      # })
      # ```
      def {{ verb.id }}(uri : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil, form : (Hash(String, _) | NamedTuple)? = nil, json : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
        headers = headers ? default_headers.merge(headers) : default_headers
        response = Halite.{{verb.id}}(build_url(uri), headers: headers, params: params, form: form, json: nil)
        validate(response)
        response
      end
    {% end %}

    # {% for method in [:get, :post, :put, :delete] %}
    #   # Return a Gitlab::Response by sending a {{method.id.upcase}} method http request
    #   #
    #   # ```
    #   # client.{{method.id}}("/path", { "key" => "value"})
    #   # ```
    #   def {{method.id}}(uri : String, options : (Hash | NamedTuple)? = nil) : Halite::Response
    #     request({{method.id.stringify}}, uri, options)
    #   end
    # {% end %}

    # # Return a `Gitlab::Response` by sending the target http request
    # #
    # # ```
    # # client.request("get", "/path", { params: {"key" => "value"})
    # # ```
    # def request(method, uri, options : (Hash | NamedTuple)? = nil) : Halite::Response
    #   conn = Halite::Client.new(default_options(uri))
    #   response = conn.request(method, build_url(uri), options)
    #   validate(response)
    #   response
    # end

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
    private def validate(response : Halite::Response)
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

    # # Sets headers and query params for requests
    # private def default_options(url, params : Hash? = nil)
    #   Hash(String, Hash(String, String)).new.tap do |hash|
    #     hash["headers"] = default_headers unless url.includes?("/session")
    #     hash["params"] = params if params
    #   end
    # end

    # Set a default Auth(PRIVATE-TOKEN or Authorization) header
    #
    # Raise an `Error::MissingCredentials` exception if token is not set.
    private def default_headers : Hash(String, String)
      raise Error::MissingCredentials.new("Please provide a private_token or auth_token for user") unless @token

      Hash(String, String).new.tap do |obj|
        if @token.size <= 20
          obj["PRIVATE-TOKEN"] = @token
        else
          obj["Authorization"] = "Bearer #{@token}"
        end

        obj["Accept"] = "application/json"
        obj["User-Agent"] = "Gitlab.cr v#{VERSION}"
      end
    end

    # Output error message
    private def error_message(response, type : ErrorType = ErrorType::JsonError)
      message = if type == ErrorType::JsonError
                  response_body = JSON.parse(response.body)
                  handle_error(response_body["message"] || response_body["error"])
                else
                  "unknown body format"
                end

      "Server responded with code #{response.status_code}, " \
      "message: #{message}. " \
      "Request URI: #{response.uri.to_s}"
    end

    include User
    include Session
    include Group
    include Project
    include Repository
    include RepositoryFile
    include Branch
    include Tag
    include Commit
    include Note
    include Issue
    include Label
    include MergeRequest
    include Milestone
    include DeployKey
    include Key
  end
end
