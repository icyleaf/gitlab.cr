require "http/client"
require "json"

module Gitlab
  module HTTP
    module Chainable

      {% for method in [:get, :post, :put, :delete] %}
        def {{method.id}}(url : String, options = {} of String => String|Hash)
          request({{method}}, url, options)
        end
      {% end %}


      def request(method : Symbol, url : String, options : Options? = nil)
        Gitlab::HTTP::Request.new(options).request(method, url)
      end

      def request(method : Symbol, url : String, options : Hash = {} of String => String|Hash)
        Gitlab::HTTP::Request.new(options).request(method, url)
      end
    end

    extend Chainable

    class Request
      @default_options : Options

      def initialize(options : Options = nil)
        @default_options = options ? options : Options.new({} of String => String)
      end

      def initialize(options : Hash = {} of String => String|Hash)
        @default_options = Options.new(options)
      end

      def get(uri)
        uri.query = [uri.query, @default_options.params].join("&") if @default_options.params
        response = ::HTTP::Client.get uri.to_s, @default_options.headers
        Response.parse(response, "GET", uri)
      end

      def post(uri)
        response = ::HTTP::Client.post_form uri.to_s, @default_options.params.to_s, @default_options.headers
        Response.parse(response, "POST", uri)
      end

      def request(method, url)
        uri = URI.parse(url)

        pp method
        pp uri.to_s
        pp @default_options

        case method
        when :get
          get(uri)
        when :post
          post(uri)
        end
      end
    end

    class Response
      @code : Int32
      @body : JSON::Any
      @method : String
      @url : URI

      getter :code, :body

      def initialize(response : ::HTTP::Client::Response, @method = nil, @url = nil)
        validate(response)

        @code = response.status_code
        @body = parse_body(response)
      end

      def self.parse(response, method = nil, url  = nil)
        Response.new(response, method, url)
      end

      private def validate(response)
        case response.status_code
        when 400 then raise BadRequest.new error_message(response)
        when 401 then raise Unauthorized.new error_message(response)
        when 403 then raise Forbidden.new error_message(response)
        when 404 then raise NotFound.new error_message(response)
        when 405 then raise MethodNotAllowed.new error_message(response)
        when 409 then raise Conflict.new error_message(response)
        when 422 then raise Unprocessable.new error_message(response)
        when 500 then raise InternalServerError.new error_message(response)
        when 502 then raise BadGateway.new error_message(response)
        when 503 then raise ServiceUnavailable.new error_message(response)
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

    class Options
      USER_AGENT = "Gitlab.cr v#{VERSION}"

      @headers : HTTP::Headers
      @params : HTTP::Params?
      @body : String?

      property :headers, :params, :body

      def initialize(options : Hash = {} of String => String|Hash)
        @headers = parse_headers(options)
        @params = parse_params(options)
        @body = parse_body(options)
      end

      private def parse_params(options)
        return unless options.has_key?("params")
        if options["params"].is_a?(String)
          build_params(options["params"].to_s)
        elsif options["params"].is_a?(Hash)
          build_params(options["params"])
        else
          raise NotMatchTypeError.new("params only support query string or form data(hash)")
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
        raise NotMatchTypeError.new("Headers only support Hash") unless options["headers"].is_a?(Hash)

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