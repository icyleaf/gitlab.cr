require "./client/user"

module Gitlab
  class Client
    def initialize(endpoint : String, token : String)
      @request = Request.new(endpoint, token)
    end

    private def get(uri, params : Params? = nil) : Gitlab::Response
      @request.exec(Gitlab::Request::Method::GET, uri)
    end

    private def post(url, params : Params? = nil)
      @request.exec(Gitlab::Request::Method::POST, uri)
    end

    private def put(url, params : Params? = nil)
      @request.exec(Gitlab::Request::Method::PUT, uri)
    end

    private def delete(url, params : Params? = nil)
      @request.exec(Gitlab::Request::Method::DELETE, uri)
    end

    include User
  end
end
