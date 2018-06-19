require "../spec_helper"

describe Gitlab::Client do
  describe ".initialize" do
    it "should initilize with api version under v1/v2/v3" do
      Gitlab::Client.new(GITLAB_ENDPOINT, GITLAB_TOKEN).should be_a Gitlab::Client
    end

    it "should throws an exception with v4 api" do
      expect_raises Gitlab::Error::NoSupportGraphQLAPIError do
        Gitlab::Client.new("https://gitlab.example.com/api/v5", GITLAB_TOKEN)
      end
    end
  end
end
