module Gitlab
  class Client
    def initialize(endpoint : String, token : String)
      @request = Request.new(endpoint, token)
    end
  end
end
