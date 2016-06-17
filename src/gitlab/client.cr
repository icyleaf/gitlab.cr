require "./client/**"

module Gitlab
  # Gitlab API Client wrapper
  #
  # See the [Gitlab Offical API Document](http://docs.gitlab.com/ce/api/README.html) for more details.
  class Client
    getter :endpoint, :token

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

    # Return a Gitlab::Response by sending the target http request
    #
    # ```
    # client.request({{method}}, "/path", { "key" => "value"})
    # ```
    def request(method, uri, params : Hash? = nil) : HTTP::Response
      HTTP.request(method, build_url(uri), default_options(uri, params))
    end

    # Return a full url string from built with base domain and url path
    private def build_url(uri)
      File.join(@endpoint, uri)
    end

    # Sets a Auth(PRIVATE-TOKEN or Authorization) header and query params for requests
    # Raise an [MissingCredentials] exception if token is not set.
    private def default_options(url, params : Hash? = nil)
      return if url.includes?("/session")

      error_message = "Please provide a private_token or auth_token for user"
      raise Error::MissingCredentials.new(error_message) unless @token

      headers = if @token.size <= 20
                  {"PRIVATE-TOKEN" => @token}
                else
                  {"Authorization" => "Bearer #{@token}"}
                end

      Hash(String, Hash(String, String)).new.tap do |hash|
        hash["headers"] = headers
        hash["params"] = params if params
      end
    end

    include User
    include Group
    include Project
  end
end
