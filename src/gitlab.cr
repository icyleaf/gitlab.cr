require "./gitlab/**"

module Gitlab
  # Alias for Gitlab::Client.new
  def self.client(endpoint : String, token : String) : Client
    Client.new(endpoint, token)
  end
end
