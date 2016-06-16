require "http/headers"
require "http/params"

module Gitlab
  module HTTP
    # HTTP Options class
    #
    # built and parse for http headers/params/body
    class Options
      USER_AGENT = "Gitlab.cr v#{VERSION}"

      @headers : HTTP::Headers?
      @params : HTTP::Params?
      @body : String?

      property :headers, :params, :body

      # Create a Http options
      def initialize(options : Hash? = nil)
        if options
          @headers = parse_headers(options)
          @params = parse_params(options)
          @body = parse_body(options)
        end
      end

      private def parse_params(options)
        return unless options.has_key?("params")
        if options["params"].is_a?(String)
          build_params(options["params"].to_s)
        elsif options["params"].is_a?(Hash)
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

      private def parse_body(options)
        return unless options.has_key?("body")

        options["body"].to_s
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