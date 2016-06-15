require "./gitlab/**"

module Gitlab
  def self.client(endpoint : String, token : String)
    Gitlab::Client.new(endpoint, token)
  end

  # Exceptions
  class Error < Exception; end
  ## Client Errors
  class NotMatchTypeError < Error; end
  ## Gitlab API Errors
  class MissingCredentials < Error; end
  class BadRequest < Error; end
  class Unauthorized < Error; end
  class Forbidden < Error; end
  class NotFound < Error; end
  class MethodNotAllowed < Error; end
  class Conflict < Error; end
  class Unprocessable < Error; end
  class InternalServerError < Error; end
  class BadGateway < Error; end
  class ServiceUnavailable < Error; end
end