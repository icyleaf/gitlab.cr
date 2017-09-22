require "../spec_helper"

Spec2.describe Gitlab::FileResponse do
  let(file) { IO::Memory.new("hello world") }
  let(empty_file) { IO::Memory.new("") }

  let(headers) { HTTP::Headers{"Content-Disposition" => "attachment; filename=\"test-master.tar.gz\""}}
  let(file_response) { Gitlab::FileResponse.new(file, headers) }

  describe ".initialize" do
    context "when empty headers or not exists `Content-Disposition` key" do
      it "should return empty filename" do
        fr = Gitlab::FileResponse.new(file, HTTP::Headers.new)
        expect(fr.filename).to eq ""
      end
    end

    context "when filename with quotes" do
      it "should return filename" do
        fr = Gitlab::FileResponse.new(file, HTTP::Headers{"Content-Disposition" => "attachment; filename=\"test-master.tar.gz\""})
        expect(fr.filename).to eq "test-master.tar.gz"
      end
    end

    context "when filename without quotes" do
      it "should return filename" do
        fr = Gitlab::FileResponse.new(file, HTTP::Headers{"Content-Disposition" => "attachment; filename=test-master.zip"})
        expect(fr.filename).to eq "test-master.zip"
      end
    end
  end

  describe ".empty?" do
    it "should return false" do
      expect(file_response.empty?).to be_false
    end
  end

  context ".to_hash" do
    it "should have `filename` key and `file` key" do
      h = file_response.to_h
      expect(h.has_key?(:filename)).to be_truthy
      expect(h.has_key?(:file)).to be_truthy
    end
  end
end
