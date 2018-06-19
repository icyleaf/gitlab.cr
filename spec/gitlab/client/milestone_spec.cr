require "../../spec_helper"

describe Gitlab::Client::Milestone do
  describe ".milestones" do
    it "should return a paginated response of project's milestones" do
      stub_get("/projects/3/milestones", "milestones")
      milestones = client.milestones(3)

      milestones.should be_a JSON::Any
      milestones[0]["project_id"].as_i.should eq 3
    end
  end

  describe ".milestone" do
    it "should return information about a milestone" do
      stub_get("/projects/3/milestones/1", "milestone")
      milestone = client.milestone(3, 1)

      milestone["project_id"].as_i.should eq 3
    end
  end

  describe ".milestone_issues" do
    it "should return a paginated response of milestone's issues" do
      stub_get("/projects/3/milestones/1/issues", "milestone_issues")
      milestone_issues = client.milestone_issues(3, 1)

      milestone_issues.should be_a JSON::Any
      milestone_issues[0]["milestone"]["id"].as_i.should eq 1
    end
  end

  describe ".milestone_merge_requests" do
    it "should return a paginated response of milestone's merge_requests" do
      stub_get("/projects/3/milestones/1/merge_requests", "milestone_merge_requests")
      milestone_merge_requests = client.milestone_merge_requests(3, 1)

      milestone_merge_requests.should be_a JSON::Any
      milestone_merge_requests[0]["milestone"]["id"].as_i.should eq 1
    end
  end

  describe ".create_milestone" do
    it "should return information about a created milestone" do
      form = {"title" => "title"}
      stub_post("/projects/3/milestones", "milestone", form: form)
      milestone = client.create_milestone(3, "title")

      milestone["project_id"].as_i.should eq 3
    end
  end

  describe ".edit_milestone" do
    it "should return information about an edited milestone" do
      form = {"title" => "title"}
      stub_put("/projects/3/milestones/33", "milestone", form: form)
      milestone = client.edit_milestone(3, 33, title: "title")

      milestone["project_id"].as_i.should eq 3
    end
  end
end
