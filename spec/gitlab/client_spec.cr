require "../spec_helper"

Spec2.describe Gitlab::Client do
  describe ".initialize" do
    it "should initilize with api version under v1/v2/v3" do
      expect(Gitlab::Client.new(GITLAB_ENDPOINT, GITLAB_TOKEN)).to be_a Gitlab::Client
    end

    it "should throws an exception with v4 api" do
      expect do
        Gitlab::Client.new("https://gitlab.example.com/api/v4", GITLAB_TOKEN)
      end.to raise_error(Gitlab::Error::NoSupportGraphQLAPIError, "Sorry, No support for GraphQL API(v4)")
    end
  end
end
