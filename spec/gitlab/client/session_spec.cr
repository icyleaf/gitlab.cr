
require "../../spec_helper"

Spec2.describe Gitlab::Client::Repository do
  describe ".session" do
    it "should return information about a created session" do
      stub_post("/session", "session", 200)
      session = client.session("email", "pass")

      expect(session["email"].as_s).to eq "john@example.com"
      expect(session["private_token"].as_s).to eq "qEsq1pt6HJPaNciie3MG"
    end
  end
end
