module Gitlab
  module HTTP
    class Multipart
      DEFAULT_BOUNDARY = "----GitlabMultipart"

      getter boundary : String
      getter length : Int32
      getter playload : String

      def initialize(name : String, file : String)
        @boundary = make_boundary
        @playload = dump_content(name, file)
        @length = @playload.size
      end

      def content_type
        "multipart/form-data; boundary=#{@boundary}"
      end

      def make_boundary
        "#{DEFAULT_BOUNDARY}#{SecureRandom.hex(6)}"
      end

      def playload(name : String, file : String)
        contents = [
          "--#{@boundary}",
          "Content-Disposition: form-data; name=\"#{name}\"; filename=\"#{file}\"",
          "Content-Type: application/octet-stream",
          "--#{@boundary}--"
        ].join("\r")
      end

      private def dump_content(name : String, file : String)
        ::File.open(file, "rb") do |f|
          f.set_encoding("UTF-8")
          content_for_tempfile(f, file, name)
        end
      end

      def content_for_tempfile(io, file, name)
        <<-EOF
        --#{@boundary}\r
        Content-Disposition: form-data; name="#{name}"; filename="#{File.basename(file)}"\r
        Content-Length: #{::File.stat(file).size}\r
        \r
        #{io.gets_to_end}\r
        --#{@boundary}--
        EOF
      end
    end
  end
end