require "json"

module Gitlab
  module CoreExt
    module StringParseJson
      # Parse self to JSON data
      #
      # ```
      # "{ \"user\": \"icyleaf\" }".parse_json # => {"user" => "hello"} : JSON::Any
      # "[]".parse_json # => [] : JSON::Any
      # ```
      def parse_json
        JSON.parse(self)
      end
    end
  end
end

# :nodoc:
class String
  include Gitlab::CoreExt::StringParseJson
end
