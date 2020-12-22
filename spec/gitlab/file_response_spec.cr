require "../spec_helper"

private def file
  IO::Memory.new("hello world")
end

private def empty_file
  IO::Memory.new("")
end

private def headers
  HTTP::Headers{"Content-Disposition" => "attachment; filename=\"test-master.tar.gz\""}
end

private def file_response
  Gitlab::FileResponse.new(file, headers)
end

describe Gitlab::FileResponse do
  describe ".initialize" do
    context "when empty headers or not exists `Content-Disposition` key" do
      it "should return empty filename" do
        fr = Gitlab::FileResponse.new(file, HTTP::Headers.new)
        fr.filename.should eq ""
      end
    end

    context "when filename with quotes" do
      it "should return filename" do
        fr = Gitlab::FileResponse.new(file, HTTP::Headers{"Content-Disposition" => "attachment; filename=\"test-master.tar.gz\""})
        fr.filename.should eq "test-master.tar.gz"
      end
    end

    context "when filename without quotes" do
      it "should return filename" do
        fr = Gitlab::FileResponse.new(file, HTTP::Headers{"Content-Disposition" => "attachment; filename=test-master.zip"})
        fr.filename.should eq "test-master.zip"
      end
    end
  end

  describe ".empty?" do
    it "should return false" do
      file_response.empty?.should be_false
    end
  end

  context ".to_hash" do
    it "should have `filename` key and `data` key" do
      h = file_response.to_h
      h.has_key?(:filename).should be_truthy
      h.has_key?(:data).should be_truthy
    end
  end
end
