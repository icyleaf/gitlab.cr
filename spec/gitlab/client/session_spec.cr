require "../../spec_helper"

describe Gitlab::Client::Session do
  describe ".session" do
    it "should return information about a created session" do
      stub_post("/session", "session", 200)
      session = client.session("email", "pass")

      session["email"].as_s.should eq "john@example.com"
      session["private_token"].as_s.should eq "qEsq1pt6HJPaNciie3MG"
    end
  end
end
