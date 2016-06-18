require "json"
require "uri"

module Gitlab
  module HTTP
    # Http Response Class
    class Response
      @url : URI
      @method : String
      @content_type : ContentType
      @code : Int32
      @body : String

      enum ContentType
        JSON
        HTML
        PlaintText
        Unknown
      end

      getter :url, :method, :content_type, :code, :body

      # Create a new Http Response
      #
      # ```
      # Gitlab::HTTP::Response.new(<HTTP::Client::Response>, "post", "http://domain.com/api/hello/world")
      # ```
      def initialize(response : ::HTTP::Client::Response, @method, @url)
        @code = response.status_code
        @content_type = content_type(response)
        @body = response.body
      end

      # Alias for Gitlab::HTTP::Response
      def self.parse(response, method = nil, url = nil) : HTTP::Response
        Response.new(response, method, url)
      end

      def parse_json
        JSON.parse(@body)
      end

      def to_s
        @body
      end

      private def content_type(response)
        case response.content_type
        when /text\/html/
          ContentType::HTML
        when /text\/plain/
          ContentType::PlaintText
        when /json/
          ContentType::JSON
        else
          ContentType::Unknown
        end
      end
    end
  end
end