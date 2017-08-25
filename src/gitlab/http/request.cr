require "http/client"
require "./request/**"

module Gitlab
  module HTTP
    # Http Request Class
    class Request
      @default_options : Options

      # Create a new http request
      #
      # ```
      # Gitlab::HTTP::Request.new
      # Gitlab::HTTP::Request.new({"headers" => {"User-Agent" => "Gitlab.cr Client"}, "params" => {"source" => "app"}})
      # ```
      def initialize(options : Hash? = nil)
        @default_options = Options.new(options)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.post("/path")
      # ```
      def post(uri) : HTTP::Response
        response = if multipart?
                     # TODO: Make it better, now just crack file to multipart request
                     multipart_file = Multipart.new("file", @default_options.params["file"])
                     set_header("Content-Type", multipart_file.content_type)
                     set_header("Content-Length", multipart_file.content_length)

                     ::HTTP::Client.post uri.to_s, @default_options.headers, multipart_file.body
                   else
                     ::HTTP::Client.post_form uri.to_s, @default_options.params.to_s, @default_options.headers
                   end

        Response.parse(response, "POST", uri)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.get("/path")
      # ```
      def get(uri) : HTTP::Response
        uri.query = [uri.query, @default_options.params].join("&") if @default_options.params
        response = ::HTTP::Client.get uri.to_s, @default_options.headers
        Response.parse(response, "GET", uri)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.put("/path")
      # ```
      def put(uri) : HTTP::Response
        uri.query = [uri.query, @default_options.params].join("&") if @default_options.params
        response = ::HTTP::Client.put uri, @default_options.headers
        Response.parse(response, "PUT", uri)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.delete("/path")
      # ```
      def delete(uri) : HTTP::Response
        uri.query = [uri.query, @default_options.params].join("&") if @default_options.params
        response = ::HTTP::Client.delete uri.to_s, @default_options.headers
        Response.parse(response, "DELETE", uri)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # Allows Methods: `GET`/`PUT`/`POST`/`DELETE`
      #
      # Raise an `Error::NotAllowRequestMethodError` exception with other method
      #
      # ```
      # request.request(:get, "/path")
      # ```
      def request(method, url) : HTTP::Response
        uri = URI.parse(url)
        case method
        when :get
          get(uri)
        when :post
          post(uri)
        when :put
          put(uri)
        when :delete
          delete(uri)
        else
          raise Error::NotAllowRequestMethodError.new("GET/PUT/POST/DELETE is allowed")
        end
      end

      # Set a header for request
      def set_header(key : String, value : String | Int32)
        @default_options.headers[key] = value.to_s
      end

      # Set a params for request
      def set_param(key : String, value : String | Int32)
        @default_options.params[key] = value.to_s
      end

      def multipart?
        @default_options.params.has_key?("file") && File.file?(@default_options.params["file"])
      end
    end
  end
end
