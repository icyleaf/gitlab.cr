require "http/client"
require "json"

module Gitlab
  module HTTP
    module Chainable
      {% for method in [:get, :post, :put, :delete] %}
        # Return a Gitlab::Response by sending a {{method.id.upcase}} method http request
        #
        # ```
        # Gitlab::HTTP.{{method.id}}("/path", { "key" => "value"})
        # ```
        def {{method.id}}(url : String, options : Hash? = nil) : Response
          request({{method}}, url, options)
        end
      {% end %}

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # Gitlab::HTTP..request({{method}}, "/path", { "key" => "value"})
      # ```
      def request(method : Symbol, url : String, options : Hash? = nil) : Response
        Gitlab::HTTP::Request.new(options).request(method, url)
      end
    end

    extend Chainable

    # Http Request Class
    class Request
      @default_options : Options

      # Create a new http request
      #
      # ```
      # Gitlab::HTTP::Request.new
      # Gitlab::HTTP::Request.new({ "headers" => { "User-Agent" => "Gitlab.cr Client"}, "params" => {"source" => "app"}})
      # ```
      def initialize(options : Hash? = nil)
        @default_options = Options.new(options)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.get("/path")
      # ```
      def get(uri) : Response
        uri.query = [uri.query, @default_options.params].join("&") if @default_options.params
        response = ::HTTP::Client.get uri.to_s, @default_options.headers
        Response.parse(response, "GET", uri)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.post("/path")
      # ```
      def post(uri) : Response
        response = ::HTTP::Client.post_form uri.to_s, @default_options.params.to_s, @default_options.headers
        Response.parse(response, "POST", uri)
      end


      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.put("/path")
      # ```
      def put(uri) : Response
        uri.query = [uri.query, @default_options.params].join("&") if @default_options.params
        response = ::HTTP::Client.put uri.to_s, @default_options.headers
        Response.parse(response, "GET", uri)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # ```
      # request.delete("/path")
      # ```
      def delete(uri) : Response
        uri.query = [uri.query, @default_options.params].join("&") if @default_options.params
        response = ::HTTP::Client.get uri.to_s, @default_options.headers
        Response.parse(response, "GET", uri)
      end

      # Return a Gitlab::Response by sending the target http request
      #
      # Allows Methods: `GET`/`PUT`/`POST`/`DELETE`
      #
      # Raise an [Error::NotAllowRequestMethodError] exception with other method
      #
      # ```
      # request.request(:get, "/path")
      # ```
      def request(method, url) : Response
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
    end

    # Http Response Class
    class Response
      @code : Int32
      @body : JSON::Any
      @method : String
      @url : URI

      getter :code, :body

      # Create a new Http Response
      #
      # ```
      # Gitlab::HTTP::Response.new(<HTTP::Client::Response>, "post", "http://domain.com/api/hello/world")
      # ```
      def initialize(response : ::HTTP::Client::Response, @method, @url)
        validate(response)

        @code = response.status_code
        @body = parse_body(response)
      end

      # Alias for Gitlab::HTTP::Response
      def self.parse(response, method = nil, url = nil)
        Response.new(response, method, url)
      end

      # Validate http response status code
      #
      # Raise an Exception if status code >= 400
      #
      # - `400`: [Error::BadRequest]
      # - `401`: [Error::Unauthorized]
      # - `403`: [Error::Forbidden]
      # - `404`: [Error::NotFound]
      # - `405`: [Error::MethodNotAllowed]
      # - `409`: [Error::Conflict]
      # - `422`: [Error::Unprocessable]
      # - `500`: [Error::InternalServerError]
      # - `502`: [Error::BadGateway]
      # - `503`: [Error::ServiceUnavailable]
      private def validate(response)
        case response.status_code
        when 400 then raise Error::BadRequest.new error_message(response)
        when 401 then raise Error::Unauthorized.new error_message(response)
        when 403 then raise Error::Forbidden.new error_message(response)
        when 404 then raise Error::NotFound.new error_message(response)
        when 405 then raise Error::MethodNotAllowed.new error_message(response)
        when 409 then raise Error::Conflict.new error_message(response)
        when 422 then raise Error::Unprocessable.new error_message(response)
        when 500 then raise Error::InternalServerError.new error_message(response)
        when 502 then raise Error::BadGateway.new error_message(response)
        when 503 then raise Error::ServiceUnavailable.new error_message(response)
        end
      end

      private def parse_body(response)
        JSON.parse(response.body)
      end

      private def error_message(response)
        response_body = parse_body(response)
        message = response_body["message"] || response_body["error"]

        "Server responded with code #{response.status_code}, " \
        "message: handle_error(#{message}). " \
        "Request URL: [#{@method}] #{@url.to_s}"
      end

      private def handle_error(message)
        case message
        when Hash
          message.to_h.sort.map do |key, val|
            "'#{key}' #{(val.is_a?(Hash) ? val.sort.map { |k, v| "(#{k}: #{v.join(' ')})" } : val).join(' ')}"
          end.join(", ")
        when Array
          message.join(" ")
        else
          message
        end
      end
    end

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
