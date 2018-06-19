require "../../spec_helper"

describe Gitlab::Client::Key do
  describe ".key" do
    it "should return information about a key" do
      stub_get("/keys/1", "key")
      key = client.key(1)

      key["id"].as_i.should eq 1
      key["title"].as_s.should eq "narkoz@helium"
    end
  end
end
