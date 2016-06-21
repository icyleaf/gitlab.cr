require "json"

module Gitlab
  module StringParseJson
    def parse_json
      JSON.parse(self)
    end
  end
end

class String
  include Gitlab::StringParseJson
end
