require "./client/user"

module Gitlab
  class Client
    getter :endpoint, :token
    def initialize(@endpoint : String, @token : String)
    end

    # TODO: HTTP request methods

    # def get(url, options : HTTP::Options = nil)
    #   HTTP.request(:get, url, default_options(url, options))
    # end

    #
    # private def post(url, params : String|Hash = nil)
    #   @request.exec(:post, uri)
    # end
    #
    # private def put(url, params : Params? = nil)
    #   @request.exec(:put, uri)
    # end
    #
    # private def delete(url, params : Params? = nil)
    #   @request.exec(:delete, uri)
    # end

    private def default_options(url, options : HTTP::Options? = nil)
      error_message = "Please provide a private_token or auth_token for user"
      raise MissingCredentials.new(error_message) unless @token

      options = HTTP::Options.new({} of String => String) unless options

      if url && url.includes?("/session")
        options
      else
        headers = if @token.size <= 20
          { "PRIVATE-TOKEN" => @token }
        else
          { "Authorization" => "Bearer #{@token}" }
        end

        new_options = { "headers" => headers }
        options.headers.merge(new_options)
      end
    end

    include User
  end
end
