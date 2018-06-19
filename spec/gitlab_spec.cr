require "./spec_helper"

describe Gitlab do
  context ".client" do
    it "should be a Gitlab::Client" do
      Gitlab.client("", "").should be_a Gitlab::Client
    end

    it "should not override each other" do
      client1 = Gitlab.client("https://api1.example.com", "001")
      client2 = Gitlab.client("https://api2.example.com", "002")
      client1.endpoint.should eq "https://api1.example.com"
      client2.endpoint.should eq "https://api2.example.com"
      client1.token.should eq "001"
      client2.token.should eq "002"
    end

    it "should set private_token to the auth_token when provided" do
      client = Gitlab.client("https://api2.example.com", "3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603")
      client.token.should eq "3225e2804d31fea13fc41fc83bffef00cfaedc463118646b154acc6f94747603"
    end
  end
end
