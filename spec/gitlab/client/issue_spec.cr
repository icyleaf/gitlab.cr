require "../../spec_helper"

describe Gitlab::Client::Issue do
  describe ".issues" do
    context "with project ID passed" do
      it "should return a paginated response of project's issues" do
        stub_get("/projects/3/issues", "project_issues")
        issues = client.issues(3)

        issues.should be_a JSON::Any
        issues[0]["project_id"].as_i.should eq 3
      end
    end

    context "with literal project ID passed" do
      it "should return a paginated response of project's issues" do
        stub_get("/projects/gitlab-org/gitlab-ce/issues", "project_issues")
        issues = client.issues("gitlab-org/gitlab-ce")

        issues.should be_a JSON::Any
        issues[0]["project_id"].as_i.should eq 3
      end
    end

    context "without project ID passed" do
      it "should return a paginated response of user's issues" do
        stub_get("/issues", "issues")
        issues = client.issues

        issues.should be_a JSON::Any
        issues[0]["closed"].as_bool.should be_falsey
        issues[0]["author"]["name"].as_s.should eq "John Smith"
      end
    end
  end

  describe ".issue" do
    it "should return information about an issue" do
      stub_get("/projects/3/issues/33", "issue")
      issue = client.issue(3, 33)

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".create_issue" do
    it "should return information about a created issue" do
      stub_post("/projects/3/issues", "issue")
      issue = client.create_issue(3, "title")

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".edit_issue" do
    it "should return information about an edited issue" do
      form = {"title" => "title"}
      stub_put("/projects/3/issues/33", "issue", form: form)
      issue = client.edit_issue(3, 33, form)

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".close_issue" do
    it "should return information about an closed issue" do
      stub_put("/projects/3/issues/33", "issue")
      issue = client.close_issue(3, 33)

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".reopen_issue" do
    it "should return information about an reopened issue" do
      stub_put("/projects/3/issues/33", "issue")
      issue = client.reopen_issue(3, 33)

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".move_issue" do
    it "should return information about the moved issue" do
      form = {"to_project_id" => "4"}
      stub_post("/projects/3/issues/33/move", "issue", form: form)
      issue = client.move_issue(3, 33, 4)

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".delete_issue" do
    it "should return information about a deleted issue" do
      stub_delete("/projects/3/issues/33", "issue")
      issue = client.delete_issue(3, 33)

      issue.should be_a JSON::Any

      issue.as(JSON::Any)["project_id"].as_i.should eq 3
      issue.as(JSON::Any)["id"].as_i.should eq 33
    end
    it "should return true since 9.0" do
      stub_delete("/projects/3/issues/34")
      result = client.delete_issue(3, 34)
      result.should be_true
    end
  end

  describe ".subscribe_issue" do
    it "should return information about the subscribed issue" do
      WebMock.reset
      stub_post("/projects/3/issues/33/subscribe", "issue")
      issue = client.subscribe_issue(3, 33)

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".unsubscribe_issue" do
    it "should return information about the unsubscribed issue" do
      stub_post("/projects/3/issues/33/unsubscribe", "issue")
      issue = client.unsubscribe_issue(3, 33)

      issue["project_id"].as_i.should eq 3
      issue["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end
end
