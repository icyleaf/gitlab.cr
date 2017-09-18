require "../../spec_helper"

Spec2.describe Gitlab::Client do
  describe ".users" do
    before { stub_get("/users", "users") }
    let(users) { client.users }

    it "should return a json data of users" do
      expect(users).to be_a JSON::Any
      expect(users[0]["email"].to_s).to eq "john@example.com"
    end
  end

  describe ".users" do
    context "with user ID passed" do
      before { stub_get("/users/1", "user") }
      let(user) { client.user(1) }

      it "should return a json data of user" do
        expect(user).to be_a JSON::Any
        expect(user["email"].to_s).to eq "john@example.com"
      end
    end

    context "withount user ID passed" do
      before { stub_get("/user", "user") }
      let(user) { client.user }

      it "should return a json data of user" do
        expect(user).to be_a JSON::Any
        expect(user["email"].to_s).to eq "john@example.com"
      end
    end
  end
end
