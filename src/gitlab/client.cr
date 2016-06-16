require "./client/user"

module Gitlab
  class Client
    getter :endpoint, :token
    def initialize(@endpoint : String, @token : String)
    end

    {% for method in [:get, :post, :put, :delete] %}
      def {{method.id}}(uri : String, params : Hash? = nil)
        request({{method}}, uri, params)
      end
    {% end %}

    def request(method, uri, params : Hash? = nil)
      HTTP.request(method, build_url(uri), default_options(uri, params))
    end

    private def build_url(uri)
      File.join(@endpoint, uri)
    end

    private def default_options(url, params : Hash? = nil)
      return if url.includes?("/session")

      error_message = "Please provide a private_token or auth_token for user"
      raise MissingCredentials.new(error_message) unless @token

      headers = if @token.size <= 20
        { "PRIVATE-TOKEN" => @token }
      else
        { "Authorization" => "Bearer #{@token}" }
      end

      Hash(String, Hash(String, String)).new.tap do |hash|
        hash["headers"] = headers
        hash["params"] = params if params
      end
    end

    include User
  end
end
