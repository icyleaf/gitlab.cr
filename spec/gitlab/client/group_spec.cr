require "../../spec_helper"

describe Gitlab::Client::Group do
  describe ".groups" do
    it "should return a paginated response of groups" do
      stub_get("/groups", "groups")
      groups = client.groups

      groups.should be_a JSON::Any
      groups[0]["path"].as_s.should eq "threegroup"
    end
  end

  describe ".group" do
    it "should return a json data of groups" do
      stub_get("/groups/3", "group")
      group = client.group(3)

      group.should be_a JSON::Any
      group["path"].as_s.should eq "gitlab-group"
    end
  end

  describe ".create_group" do
    context "without description" do
      it "should return information about a created group" do
        stub_post("/groups", "group_create")
        group = client.create_group("GitLab-Group", "gitlab-path")

        group["name"].as_s.should eq "Gitlab-Group"
        group["path"].as_s.should eq "gitlab-group"
      end
    end

    context "with description" do
      it "should return information about a created group" do
        WebMock.reset
        stub_post("/groups", "group_create_with_description")
        group = client.create_group("GitLab-Group", "gitlab-path", {"description" => "gitlab group description"})

        group["name"].as_s.should eq "Gitlab-Group"
        group["path"].as_s.should eq "gitlab-group"
        group["description"].as_s.should eq "gitlab group description"
      end
    end
  end

  describe ".edit_group" do
    it "should return information about a edited group" do
      form = {"name" => "Gitlab-Edited"}
      stub_put("/groups/3", "group_edit", form: form)
      group = client.edit_group(3, form)

      group["name"].as_s.should eq "Gitlab-Edited"
      group["path"].as_s.should eq "gitlab-group"
    end
  end

  describe ".delete_group" do
    it "should return information about a deleted group" do
      stub_delete("/groups/42", "group_delete")
      group = client.delete_group(42)

      group["name"].as_s.should eq "Gitlab-Group"
      group["path"].as_s.should eq "gitlab-group"
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

      group_transfer["name"].should eq group["name"]
      group_transfer["path"].should eq group["path"]
      group_transfer["id"].should eq group["id"]
    end
  end

  describe ".group_members" do
    it "should return information about a group's members" do
      stub_get("/groups/3/members", "group_members")
      members = client.group_members(3)

      members.should be_a JSON::Any
      members.size.should eq 2
      members[1]["name"].as_s.should eq "John Smith"
    end
  end

  describe ".group_member" do
    it "should return information about a group member" do
      stub_get("/groups/3/members/2", "group_member")
      member = client.group_member(3, 2)

      member.should be_a JSON::Any
      member["access_level"].as_i.should eq 10
      member["name"].as_s.should eq "John Smith"
    end
  end

  describe ".add_group_member" do
    it "should return information about the added member" do
      stub_post("/groups/3/members", "group_member")
      member = client.add_group_member(3, 1, 40)
      member["name"].as_s.should eq "John Smith"
    end
  end

  describe ".edit_group_member" do
    it "should return information about the edited member" do
      stub_put("/groups/3/members/1", "group_member_edit")
      member = client.edit_group_member(3, 1, 50)

      member["access_level"].as_i.should eq 50
    end
  end

  describe ".remove_group_member" do
    it "should return information about the group the member was removed from" do
      stub_delete("/groups/3/members/1", "group_member_delete")
      group = client.remove_group_member(3, 1)

      group["group_id"].as_i.should eq 3
    end
  end

  describe ".group_projects" do
    it "should return a list of of projects under a group" do
      stub_get("/groups/4/projects", "group_projects")
      projects = client.group_projects(4)

      projects.should be_a JSON::Any
      projects.size.should eq 1
      projects[0]["name"].as_s.should eq "Diaspora Client"
    end
  end

  describe ".group_search" do
    it "should return an array of groups found" do
      stub_get("/groups?search=Group", "group_search")
      groups = client.group_search("Group")

      groups[0]["id"].as_i.should eq 5
      groups[-1]["id"].as_i.should eq 8
    end
  end

  describe ".custom_attributes" do
    it "should return a json data of group's custom attributes" do
      stub_get("/groups/1/custom_attributes", "group_add_custom_attribute")
      result = client.group_custom_attributes(1)

      result["key"].as_s.should eq "custom_key"
      result["value"].as_s.should eq "custom_value"
    end
  end

  describe ".add_custom_attribute" do
    it "should return boolean" do
      params = {"value" => "custom_value"}
      stub_put("/groups/1/custom_attributes/custom_key", "group_add_custom_attribute", params)

      result = client.group_add_custom_attribute(1, "custom_key", params )
      result["key"].as_s.should eq "custom_key"
      result["value"].as_s.should eq "custom_value"
    end
  end

  describe ".delete_custom_attribute" do
    it "should return boolean" do
      stub_delete("/groups/1/custom_attributes/custom_key","group_delete_custom_attribute")

      result = client.group_delete_custom_attribute(1, "custom_key")
      result.size.should eq 0
    end
  end

end
