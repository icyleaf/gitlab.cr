require "../spec_helper"

describe Gitlab::Client do
  describe ".initialize" do
    it "should initilize with api version under v1/v2/v3/v4" do
      Gitlab::Client.new(GITLAB_ENDPOINT, GITLAB_TOKEN).should be_a Gitlab::Client
    end

    it "should throws an exception with v5 api" do
      expect_raises Gitlab::Error::NoSupportGraphQLAPIError do
        Gitlab::Client.new("https://gitlab.example.com/api/v5", GITLAB_TOKEN)
      end
    end
  end

  describe ".available?" do
    it "should return true if service works" do
      stub_get("/user", "user")
      client.available?.should be_true
    end
  end
end
