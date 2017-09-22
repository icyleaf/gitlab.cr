require "../../spec_helper"

Spec2.describe Gitlab::Client::DeployKey do
  describe ".deploy_keys" do
    it "should return project deploy keys" do
      stub_get("/projects/42/deploy_keys", "project_keys")
      deploy_keys = client.deploy_keys(42)

      expect(deploy_keys).to be_a JSON::Any
      expect(deploy_keys[0]["id"].as_i).to eq 2
      expect(deploy_keys[0]["title"].as_s).to eq "Key Title"
      expect(deploy_keys[0]["key"].as_s).to match(/ssh-rsa/)
    end
  end

  describe ".deploy_key" do
    it "should return project deploy key" do
      stub_get("/projects/42/deploy_keys/2", "project_key")
      deploy_key = client.deploy_key(42, 2)

      expect(deploy_key["id"].as_i).to eq 2
      expect(deploy_key["title"].as_s).to eq "Key Title"
      expect(deploy_key["key"].as_s).to match(/ssh-rsa/)
    end
  end

  describe ".create_deploy_key" do
    it "should return information about a created deploy key" do
      form = {"title" => "Key Title", "key" => "ssh-rsa AAAABBBCCCDDDEEEFFF"}
      stub_post("/projects/42/deploy_keys", "project_key", form: form)
      deploy_key = client.create_deploy_key(42, form["title"], form["key"])

      expect(deploy_key["id"].as_i).to eq 2
      expect(deploy_key["title"].as_s).to eq "Key Title"
      expect(deploy_key["key"].as_s).to match(/ssh-rsa/)
    end
  end

  describe ".remove_deploy_key" do
    it "should return information about a deleted key" do
      stub_delete("/projects/42/deploy_keys/2", "project_key")
      deploy_key = client.remove_deploy_key(42, 2)

      expect(deploy_key["id"].as_i).to eq 2
    end
  end

  describe ".enable_deploy_key" do
    it "should return information about an enabled key" do
      stub_post("/projects/42/deploy_keys/2/enable", "project_key")
      deploy_key = client.enable_deploy_key(42, 2)

      expect(deploy_key["id"].as_i).to eq 2
    end
  end

  describe ".disable_deploy_key" do
    it "should return information about a disabled key" do
      stub_post("/projects/42/deploy_keys/2/disable", "project_key")
      deploy_key = client.disable_deploy_key(42, 2)

      expect(deploy_key["id"].as_i).to eq 2
    end
  end
end
