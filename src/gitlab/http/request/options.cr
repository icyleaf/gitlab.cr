require "http/headers"
require "http/params"

module Gitlab
  module HTTP
    # HTTP Options class
    #
    # built and parse for http headers/params/body
    class Options
      USER_AGENT = "Gitlab.cr v#{VERSION}"

      property headers : ::HTTP::Headers
      property params : ::HTTP::Params

      # Create a Http options
      def initialize(options : Hash? = nil)
        @headers = parse_headers(options)
        @params = parse_params(options)
      end

      private def parse_params(options)
        return ::HTTP::Params.new({} of String => Array(String)) unless options.has_key?("params")

        case options["params"]
        when String|Int32
          build_params(options["params"])
        when Hash
          build_params(options["params"])
        else
          raise Error::NotMatchTypeError.new("params only support query string or form data(hash)")
        end
      end

      private def build_params(query : String)
        HTTP::Params.parse(query)
      end

      private def build_params(params : Hash)
        HTTP::Params.new({} of String => Array(String)).tap do |param|
          params.each do |key, value|
            param.add(key, value)
          end
        end
      end

      private def parse_headers(options)
        return default_headers unless options.has_key?("headers")
        raise Error::NotMatchTypeError.new("Headers only support Hash") unless options["headers"].is_a?(Hash)

        default_headers.tap do |header|
          options["headers"].each do |key, value|
            header[key] = value
          end
        end
      end

      private def default_headers
        HTTP::Headers.new.tap do |header|
          header["User-Agent"] = USER_AGENT
        end
      end
    end
  end
end