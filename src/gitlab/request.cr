require "http/client"
require "http/headers"
require "http/params"

module Gitlab
  class Request
    USER_AGENT = "Gitlab.cr v#{VERSION}"

    enum Method
      GET
      POST
      PUT
      DELETE
    end

    @headers : HTTP::Headers

    getter :url, :token, :headers

    def initialize(@url : String, @token : String)
      @headers = default_headers
    end

    def exec(method : Method, uri : String, params : Params? = nil)
      request_method = method.to_s
      request_url = build_url(uri)
      Response.new(HTTP::Client.exec(request_method, request_url, @headers), request_method, request_url)
    end

    private def build_url(uri : String)
      File.join(@url, uri)
    end

    private def default_headers(path = nil)
      HTTP::Headers.new.tap do |headers|
        headers["User-Agent"] = USER_AGENT

        unless path == "/session"
          error_message = "Please provide a private_token or auth_token for user"
          raise Error::MissingCredentials.new(error_message) unless @token
          if @token.size <= 20
            headers["PRIVATE-TOKEN"] = @token
          else
            headers["Authorization"] = "Bearer #{@token}"
          end
        end
      end
    end
  end
end
