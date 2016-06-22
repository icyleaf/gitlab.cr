require "http/headers"
require "http/params"

module Gitlab
  module HTTP
    # HTTP Options class
    #
    # built and parse for http headers/params/body
    #
    # ```
    # options = Gitlab::HTTP::Options.new({
    #   "headers" => {
    #     "User-Agent" => "Gitlab.cr v0.1.0",
    #   },
    #   "params" => {
    #     "username" => "icyleaf",
    #     "password" => "p@ssw0rd",
    #   }
    # })
    #
    # # Or only pass header or params is okay.
    # options = Gitlab::HTTP::Options.new({
    #   "headers" => {
    #     "User-Agent" => "Gitlab.cr v0.1.0",
    #   }
    # })
    #
    # # append more headers
    # options.headers["Content-Type"] = "application/json"
    # ```
    class Options
      USER_AGENT = "Gitlab.cr v#{VERSION}"

      property headers : ::HTTP::Headers
      property params : ::HTTP::Params

      alias Params = String|Int32|File|Float32

      # Create a Http options
      def initialize(options : Hash = nil)
        @headers = parse_headers(options)
        @params = parse_params(options)
      end

      private def parse_params(options)
        return ::HTTP::Params.new({} of String => Array(String)) unless options.has_key?("params")

        build_params(options["params"])
      end

      private def build_params(query : String)
        HTTP::Params.parse(query)
      end

      private def build_params(params : Hash(String, String))
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