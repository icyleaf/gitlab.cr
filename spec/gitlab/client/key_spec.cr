require "../../spec_helper"

Spec2.describe Gitlab::Client::Key do
  describe ".key" do
    it "should return information about a key" do
      stub_get("/keys/1", "key")
      key = client.key(1)

      expect(key["id"].as_i).to eq 1
      expect(key["title"].as_s).to eq "narkoz@helium"
    end
  end
end
