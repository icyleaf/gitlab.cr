require "./gitlab/**"

module Gitlab
  def self.client(endpoint : String, token : String)
    Gitlab::Client.new(endpoint, token)
  end
end