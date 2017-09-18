require "../../spec_helper"

Spec2.describe Gitlab::Client::User do
  describe ".users" do
    it "should return a json data of users" do
      stub_get("/users", "users")
      users = client.users

      expect(users).to be_a JSON::Any
      expect(users[0]["email"].as_s).to eq "john@example.com"
    end
  end

  describe ".user" do
    context "with user ID passed" do
      it "should return a json data of user" do
        stub_get("/users/1", "user")
        user = client.user(1)

        expect(user).to be_a JSON::Any
        expect(user["email"].as_s).to eq "john@example.com"
      end
    end

    context "withount user ID passed" do
      it "should return a json data of user" do
        stub_get("/user", "user")
        user = client.user

        expect(user).to be_a JSON::Any
        expect(user["email"].as_s).to eq "john@example.com"
      end
    end
  end

  describe ".create_user" do
    context "when successful request" do
      it "should return information about a created user" do
        stub_post("/users", "user")

        user = client.create_user("email", "pass", "username")
        expect(user["email"].as_s).to eq "john@example.com"
      end
    end

    context "when bad request" do
      it "should throw an exception" do
        WebMock.reset
        stub_post("/users", "error_already_exists", 409)

        expect do
          client.create_user("email", "pass", "username")
        end.to raise_error(Gitlab::Error::Conflict, "Server responded with code 409, message: 409 Already exists. Request URI: #{client.endpoint}/users")
      end
    end
  end

  describe ".edit_user" do
    it "should get the correct resource" do
      params = { "name" => "Roberto" }
      stub_put("/users/1", "user", params)
      user = client.edit_user(1, params)

      expect(user["email"].as_s).to eq "john@example.com"
    end
  end

  describe ".delete_user" do
    it "should return information about a deleted user" do
      stub_delete("/users/1", "user")

      user = client.delete_user(1)
      expect(user["email"].as_s).to eq "john@example.com"
    end
  end

  describe ".block_user" do
    it "should return boolean" do
      stub_put("/users/1/block", "user_block_unblock")

      result = client.block_user(1)
      expect(result.as_bool).to be_true
    end
  end

  describe ".unblock_user" do
    it "should return boolean" do
      stub_put("/users/1/unblock", "user_block_unblock")

      result = client.unblock_user(1)
      expect(result.as_bool).to be_true
    end
  end

  describe ".session" do
    it "should return information about a created session" do
      stub_post("/session", "session", 200)
      session = client.session("email", "pass")

      expect(session["email"].as_s).to eq "john@example.com"
      expect(session["private_token"].as_s).to eq "qEsq1pt6HJPaNciie3MG"
    end
  end

  describe ".ssh_keys" do
    context "with user ID passed" do
      it "should return a paginated response of SSH keys" do
        stub_get("/users/1/keys", "keys")
        keys = client.ssh_keys(1)

        expect(keys).to be_a JSON::Any
        expect(keys[0]["title"].as_s).to eq "narkoz@helium"
      end
    end

    context "without user ID passed" do
      it "should return a paginated response of SSH keys" do
        stub_get("/user/keys", "keys")

        keys = client.ssh_keys
        expect(keys).to be_a JSON::Any
        expect(keys[0]["title"].as_s).to eq "narkoz@helium"
      end
    end
  end

  describe ".create_ssh_key" do
    it "should return information about a created SSH key" do
      stub_post("/user/keys", "key")
      key = client.create_ssh_key("title", "body")

      expect(key["title"].as_s).to eq "narkoz@helium"
    end
  end

  describe ".delete_ssh_key" do
    it "should return information about a deleted SSH key" do
      stub_delete("/user/keys/1", "key")
      key = client.delete_ssh_key(1)

      expect(key["title"].as_s).to eq "narkoz@helium"
    end
  end

  describe ".emails" do
    describe "without user ID" do
      it "should return a information about a emails of user" do
        stub_get("/user/emails", "user_emails")
        emails = client.emails

        expect(emails[0]["id"].as_i).to eq 1
        expect(emails[0]["email"].as_s).to eq "email@example.com"
      end
    end

    describe "with user ID" do
      it "should return a information about a emails of user" do
        stub_get("/users/2/emails", "user_emails")
        emails = client.emails(2)

        expect(emails[0]["id"].as_i).to eq 1
        expect(emails[0]["email"].as_s).to eq "email@example.com"
      end
    end
  end


  describe ".add_email" do
    describe "without user ID" do
      it "should return information about a new email" do
        stub_post("/user/emails", "user_email")
        email = client.add_email("email@example.com")

        expect(email["id"].as_i).to eq 1
        expect(email["email"].as_s).to eq "email@example.com"
      end
    end

    describe "with user ID" do
      it "should return information about a new email" do
        stub_post("/users/2/emails", "user_email")
        email = client.add_email(2, "email@example.com")

        expect(email["id"].as_i).to eq 1
        expect(email["email"].as_s).to eq "email@example.com"
      end
    end
  end

  describe ".delete_email" do
    describe "without user ID" do
      it "should return information about a deleted email" do
        stub_delete("/user/emails/1", "user_email")

        email = client.delete_email(1)
        expect(email).to be_truthy
      end
    end

    describe "with user ID" do
      it "should return information about a deleted email" do
        stub_delete("/users/2/emails/1", "user_email")
        email = client.delete_email(1, 2)

        expect(email).to be_truthy
      end
    end
  end

  describe ".user_search" do
    it "should return an array of users found" do
      stub_get("/users?search=User", "user_search")
      users = client.user_search("User")

      expect(users[0]["id"].as_i).to eq(1)
      expect(users[-1]["id"].as_i).to eq(2)
    end
  end
end
