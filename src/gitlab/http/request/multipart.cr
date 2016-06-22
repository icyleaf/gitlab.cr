module Gitlab
  module HTTP
    class Multipart
      DEFAULT_BOUNDARY = "----GitlabMultipart"

      getter boundary : String
      getter body : String

      def initialize(name : String, file : String)
        @boundary = make_boundary
        @body = make_body(name, file)
      end

      def content_type
        "multipart/form-data; boundary=#{@boundary}"
      end

      def content_length
        @body.size
      end

      private def make_boundary
        "#{DEFAULT_BOUNDARY}#{SecureRandom.hex(6)}"
      end

      private def make_body(name : String, file : String)
        ::File.open(file, "rb") do |f|
          f.set_encoding("UTF-8")
          content_for_tempfile(f, file, name)
        end
      end

      def content_for_tempfile(io, file, name)
        <<-EOF
        --#{@boundary}\r
        Content-Disposition: form-data; name="#{name}"; filename="#{File.basename(file)}"\r
        Content-Length: #{File.stat(file).size}\r
        \r
        #{io.gets_to_end}\r
        --#{@boundary}--
        EOF
      end
    end
  end
end