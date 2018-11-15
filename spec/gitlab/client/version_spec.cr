require "../../spec_helper"

describe Gitlab::Client::Version do
  describe ".version" do
    it "returns information about gitlab server" do
      stub_get("/version", "version")
      version = client.version

      version["version"].should eq "8.13.0-pre"
      version["revision"].should eq "4e963fe"
    end
  end
end
