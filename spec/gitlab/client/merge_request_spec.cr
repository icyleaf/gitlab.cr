require "../../spec_helper"

describe Gitlab::Client::MergeRequest do
  describe ".merge_requests" do
    it "should return a paginated response of project's merge requests" do
      stub_get("/projects/3/merge_requests", "merge_requests")
      merge_requests = client.merge_requests(3)

      merge_requests.should be_a JSON::Any
      merge_requests[0]["project_id"].as_i.should eq 3
    end
  end

  describe ".merge_request" do
    it "should return information about a merge request" do
      stub_get("/projects/3/merge_requests/1", "merge_request")
      merge_request = client.merge_request(3, 1)

      merge_request["project_id"].as_i.should eq 3
      merge_request["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".create_merge_request" do
    it "should return information about a merge request" do
      form = {
        "source_branch" => "api",
        "target_branch" => "master",
        "title"         => "New feature",
      }
      stub_post("/projects/3/merge_requests", "merge_request", form: form)
      merge_request = client.create_merge_request(3, "api", "master", "New feature")

      merge_request["project_id"].as_i.should eq 3
      merge_request["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".update_merge_request" do
    it "should return information about a merge request" do
      form = {
        "assignee_id"   => "1",
        "target_branch" => "master",
        "title"         => "A different new feature",
      }
      stub_put("/projects/3/merge_requests/2", "merge_request", form: form)
      merge_request = client.update_merge_request(3, 2, form)

      merge_request["project_id"].as_i.should eq 3
      merge_request["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".accept_merge_request" do
    it "should return information about merged merge request" do
      form = {"merge_commit_message" => "Nice!"}
      stub_put("/projects/5/merge_requests/42/merge", "merge_request", form: form)
      merge_request = client.accept_merge_request(5, 42, form)

      merge_request["project_id"].as_i.should eq 3
      merge_request["assignee"]["name"].as_s.should eq "Jack Smith"
    end
  end

  describe ".merge_request_notes" do
    it "should return merge request's comments" do
      stub_get("/projects/3/merge_requests/2/notes", "merge_request_comments")
      merge_request = client.merge_request_notes(3, 2)

      merge_request.should be_a JSON::Any
      merge_request.size.should eq 2
      merge_request[0]["note"].as_s.should eq "this is the 1st comment on the 2merge merge request"
      merge_request[0]["author"]["id"].as_i.should eq 11
      merge_request[1]["note"].as_s.should eq "another discussion point on the 2merge request"
      merge_request[1]["author"]["id"].as_i.should eq 12
    end
  end

  describe ".create_merge_request_note" do
    it "should return information about a merge request" do
      stub_post("/projects/3/merge_requests/2/notes", "merge_request_comment")
      merge_request = client.create_merge_request_note(3, 2, "Cool Merge Request!")

      merge_request["note"].as_s.should eq "Cool Merge Request!"
      merge_request["author"]["id"].as_i.should eq 1
    end
  end

  describe ".merge_request_changes" do
    it "should return the merge request changes" do
      stub_get("/projects/3/merge_requests/2/changes", "merge_request_changes")
      mr_changes = client.merge_request_changes(3, 2)

      mr_changes["changes"][0]["old_path"].as_s.should eq "lib/omniauth/builder.rb"
      mr_changes["id"].as_i.should eq 2
      mr_changes["project_id"].as_i.should eq 3
      mr_changes["source_branch"].as_s.should eq "uncovered"
      mr_changes["target_branch"].as_s.should eq "master"
    end
  end

  describe ".merge_request_commits" do
    it "should return the merge request commits" do
      stub_get("/projects/3/merge_requests/2/commits", "merge_request_commits")
      mr_commits = client.merge_request_commits(3, 2)

      mr_commits.should be_a JSON::Any
      mr_commits.size.should eq 2
      mr_commits[0]["id"].as_s.should eq "a2da7552f26d5b46a6a09bb8b7b066e3a102be7d"
      mr_commits[0]["short_id"].as_s.should eq "a2da7552"
      mr_commits[0]["title"].as_s.should eq "piyo"
      mr_commits[0]["author_name"].as_s.should eq "example"
      mr_commits[0]["author_email"].as_s.should eq "example@example.com"
      mr_commits[1]["short_id"].as_s.should eq "3ce50959"
      mr_commits[1]["title"].as_s.should eq "hoge"
    end
  end

  describe ".merge_request_closes_issues" do
    it "should return a paginated response of the issues the merge_request will close" do
      stub_get("/projects/5/merge_requests/1/closes_issues", "merge_request_closes_issues")
      issues = client.merge_request_closes_issues(5, 1)

      issues.should be_a JSON::Any
      issues[0]["title"].as_s.should eq "Merge request 1 issue 1"
      issues.size.should eq 2
    end
  end

  describe ".subscribe_merge_request" do
    it "should return information about a merge request" do
      stub_post("/projects/3/merge_requests/2/subscribe", "merge_request")
      merge_request = client.subscribe_merge_request(3, 2)

      merge_request["project_id"].as_i.should eq 3
    end
  end

  describe ".unsubscribe_merge_request" do
    it "should return information about a merge request" do
      stub_post("/projects/3/merge_requests/2/unsubscribe", "merge_request")
      merge_request = client.unsubscribe_merge_request(3, 2)

      merge_request["project_id"].as_i.should eq 3
    end
  end

  describe ".cancel_merge_request_when_build_succeed" do
    pending { "TODO" }
  end
end
