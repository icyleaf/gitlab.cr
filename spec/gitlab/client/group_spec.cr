require "../../spec_helper"

Spec2.describe Gitlab::Client::Group do
  describe ".groups" do
    it "should return a paginated response of groups" do
      stub_get("/groups", "groups")
      groups = client.groups

      expect(groups).to be_a JSON::Any
      expect(groups[0]["path"].as_s).to eq "threegroup"
    end
  end

  describe ".group" do
    it "should return a json data of groups" do
      stub_get("/groups/3", "group")
      group = client.group(3)

      expect(group).to be_a JSON::Any
      expect(group["path"].as_s).to eq "gitlab-group"
    end
  end

  describe ".create_group" do
    context "without description" do
      it "should return information about a created group" do
        stub_post("/groups", "group_create")
        group = client.create_group("GitLab-Group", "gitlab-path")

        expect(group["name"].as_s).to eq "Gitlab-Group"
        expect(group["path"].as_s).to eq "gitlab-group"
      end
    end

    context "with description" do
      it "should return information about a created group" do
        WebMock.reset
        stub_post("/groups", "group_create_with_description")
        group = client.create_group("GitLab-Group", "gitlab-path", "gitlab group description")

        expect(group["name"].as_s).to eq "Gitlab-Group"
        expect(group["path"].as_s).to eq "gitlab-group"
        expect(group["description"].as_s).to eq "gitlab group description"
      end
    end
  end

  describe ".delete_group" do
    it "should return information about a deleted group" do
      stub_delete("/groups/42", "group_delete")
      group = client.delete_group(42)

      expect(group["name"].as_s).to eq "Gitlab-Group"
      expect(group["path"].as_s).to eq "gitlab-group"
    end
  end

  describe ".transfer_project_to_group" do
    it "should return information about the group" do
      stub_post("/projects", "project")
      project = client.create_project("Gitlab")
      stub_post("/groups", "group_create")
      group = client.create_group("GitLab-Group", "gitlab-path")

      stub_post("/groups/#{group["id"]}/projects/#{project["id"]}", "group_create")
      group_transfer = client.transfer_project_to_group(group["id"], project["id"])

      expect(group_transfer["name"]).to eq group["name"]
      expect(group_transfer["path"]).to eq group["path"]
      expect(group_transfer["id"]).to eq group["id"]
    end
  end

  describe ".group_members" do
    it "should return information about a group's members" do
      stub_get("/groups/3/members", "group_members")
      members = client.group_members(3)

      expect(members).to be_a JSON::Any
      expect(members.size).to eq 2
      expect(members[1]["name"].as_s).to eq "John Smith"
    end
  end

  describe ".group_member" do
    it "should return information about a group member" do
      stub_get("/groups/3/members/2", "group_member")
      member = client.group_member(3, 2)

      expect(member).to be_a JSON::Any
      expect(member["access_level"].as_i).to eq 10
      expect(member["name"].as_s).to eq "John Smith"
    end
  end

  describe ".add_group_member" do
    it "should return information about the added member" do
      stub_post("/groups/3/members", "group_member")
      member = client.add_group_member(3, 1, 40)
      expect(member["name"].as_s).to eq "John Smith"
    end
  end

  describe ".edit_group_member" do
    it "should return information about the edited member" do
      stub_put("/groups/3/members/1", "group_member_edit")
      member = client.edit_group_member(3, 1, 50)

      expect(member["access_level"].as_i).to eq 50
    end
  end

  describe ".remove_group_member" do
    it "should return information about the group the member was removed from" do
      stub_delete("/groups/3/members/1", "group_member_delete")
      group = client.remove_group_member(3, 1)

      expect(group["group_id"].as_i).to eq 3
    end
  end

  describe ".group_projects" do
    it "should return a list of of projects under a group" do
      stub_get("/groups/4/projects", "group_projects")
      projects = client.group_projects(4)

      expect(projects).to be_a JSON::Any
      expect(projects.size).to eq 1
      expect(projects[0]["name"].as_s).to eq "Diaspora Client"
    end
  end

  describe ".group_search" do
    it "should return an array of groups found" do
      stub_get("/groups?search=Group", "group_search")
      groups = client.group_search("Group")

      expect(groups[0]["id"].as_i).to eq 5
      expect(groups[-1]["id"].as_i).to eq 8
    end
  end
end
