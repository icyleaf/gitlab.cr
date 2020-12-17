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

  describe ".key_by_fingerprint" do
    it "should return information about a key" do
      stub_get("/keys?fingerprint=9f:70:33:b3:50:4d:9a:a3:ef:ea:13:9b:87:0f:7f:7e", "key")
      key = client.key_by_fingerprint("9f:70:33:b3:50:4d:9a:a3:ef:ea:13:9b:87:0f:7f:7e")

      key["id"].as_i.should eq 1
      key["title"].as_s.should eq "narkoz@helium"
    end
  end
end
