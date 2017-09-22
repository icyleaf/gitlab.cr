module Gitlab
  struct FileResponse
    getter filename : String
    getter file : IO

    def initialize(@file : IO, headers : HTTP::Headers)
      @filename = parse_filename(headers)
    end

    def empty?
      false
    end

    def to_h
      {
        filename: @filename,
        file:     @file,
      }
    end

    private def parse_filename(headers) : String
      return "" unless headers.has_key?("Content-Disposition") && headers["Content-Disposition"].includes?("filename=")

      filename = headers["Content-Disposition"].split("filename=")[1]
      filename = filename[1...-1] if filename[0] == '"'
      filename
    end
  end
end
