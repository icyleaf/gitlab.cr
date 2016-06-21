require "../../spec_helper"

def users
  stub_get("/users", "users")
  client.users
end

describe Gitlab::Client do
  describe ".users" do
    it "should return a paginated response of users" do
      users.should_not be_nil # eq("john@example.com")
    end

    it "should return a paginated response of users" do
      users[0]["email"].should eq("john@example.com")
    end
  end
end
