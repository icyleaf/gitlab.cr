require "./spec_helper"

Spec2.describe Gitlab do
  describe ".client" do
    it "should be a Gitlab::Client" do
      expect(Gitlab.client("", "")).to be_a Gitlab::Client
    end

    it "should not override each other" do
      client1 = Gitlab.client("https://api1.example.com", "001")
      client2 = Gitlab.client("https://api2.example.com", "002")
      expect(client1.endpoint).to eq "https://api1.example.com"
      expect(client2.endpoint).to eq "https://api2.example.com"
      expect(client1.token).to eq "001"
      expect(client2.token).to eq "002"
    end

    it "should set private_token to the auth_token when provided" do
      client = Gitlab.client("https://api2.example.com", "3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603")
      expect(client.token).to eq "3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603"
    end
  end
end
