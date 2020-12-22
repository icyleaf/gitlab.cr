require "./client/**"
require "halite"
require "json"

module Gitlab
  # Gitlab API Client wrapper
  #
  # See the [Gitlab Offical API Document](http://docs.gitlab.com/ce/api/README.html) for more details.
  class Client
    # The endpoint of Gitlab
    getter endpoint : String

    # The token(private-token or OAuth2 access token) of Gitlab
    property token : String

    # :nodoc:
    enum ErrorType
      JsonError
      NonJsonError
    end

    @connection : Halite::Client

    # Create a new client
    #
    # ```
    # Gitlab::Client.new("<endpoint>", "<token")
    # ```
    def initialize(@endpoint : String, @token : String)
      if @endpoint.includes?("api/graphql")
        message = "Sorry, No support for GraphQL API, Check out: " \
                  "https://docs.gitlab.com/ce/api/README.html#road-to-graphql"
        raise Gitlab::Error::NoSupportGraphQLAPIError.new(message)
      end

      @connection = Halite::Client.new(endpoint: @endpoint, headers: default_headers)
    end

    # Setter for endpoint
    def endpoint=(endpoint : String)
      @endpoint = endpoint
      @connection.endpoint = @endpoint
    end

    {% for verb in %w(get head) %}
      # Return a Halite::Response by sending a {{verb.id.upcase}} method http request
      #
      # ```
      # client.{{ verb.id }}("path", params: {
      #   first_name: "foo",
      #   last_name:  "bar"
      # })
      # ```
      def {{ verb.id }}(path : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
        response = @connection.{{verb.id}}(path, headers: headers, params: params)
        validate(response)
        response
      end
    {% end %}

    {% for verb in %w(post put patch delete) %}
      # Return a `Halite::Response` by sending a {{verb.id.upcase}} http request
      #
      # ```
      # client.{{ verb.id }}("path", form: {
      #   first_name: "foo",
      #   last_name:  "bar"
      # })
      # ```
      def {{ verb.id }}(path : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil, form : (Hash(String, _) | NamedTuple)? = nil, json : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
        response = @connection.{{verb.id}}(path, headers: headers, params: params, form: form, json: nil)
        validate(response)
        response
      end
    {% end %}

    # Return a `Bool` status by gitlab api service
    #
    # - Return `Bool`
    #
    # ```
    # client.available? # => true
    # ```
    def available?
      get("user")
      true
    rescue Halite::Exception::ConnectionError
      false
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
      when 400 then raise Error::BadRequest.new(response)
      when 401 then raise Error::Unauthorized.new(response)
      when 403 then raise Error::Forbidden.new(response)
      when 404 then raise Error::NotFound.new(response)
      when 405 then raise Error::MethodNotAllowed.new(response)
      when 409 then raise Error::Conflict.new(response)
      when 422 then raise Error::Unprocessable.new(response)
      when 500 then raise Error::InternalServerError.new(response)
      when 502 then raise Error::BadGateway.new(response)
      when 503 then raise Error::ServiceUnavailable.new(response)
      end
    end

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
    include Version
  end
end
