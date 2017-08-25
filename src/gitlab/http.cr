module Gitlab
  module HTTP
    module Chainable
      {% for method in [:get, :post, :put, :delete] %}
        # Return a Gitlab::Response by sending a {{method.id.upcase}} method http request
        #
        # ```
        # Gitlab::HTTP.{{method.id}}("/path", { "key" => "value"})
        # ```
        def {{method.id}}(url : String, options : Hash? = nil) : HTTP::Response
          request({{method}}, url, options)
        end
      {% end %}

      # Return a `Gitlab::Response` by sending the target http request
      #
      # ```
      # Gitlab::HTTP..request({{method}}, "/path", {"key" => "value"})
      # ```
      def request(method : Symbol, url : String, options : Hash? = nil) : HTTP::Response
        Gitlab::HTTP::Request.new(options).request(method, url)
      end
    end

    extend Chainable
  end
end
