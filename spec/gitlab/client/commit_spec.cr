require "../../spec_helper"

describe Gitlab::Client::Commit do
  describe ".commits" do
    it "should return a paginated response of repository commits" do
      params = {"ref_name" => "api"}
      stub_get("/projects/3/repository/commits", "project_commits", params)
      commits = client.commits(3, params)

      commits.should be_a JSON::Any
      commits[0]["id"].as_s.should eq "f7dd067490fe57505f7226c3b54d3127d2f7fd46"
    end
  end

  describe ".commit" do
    it "should return a repository commit" do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6", "project_commit")
      commit = client.commit(3, "6104942438c14ec7bd21c6cd5bd995272b3faff6")

      commit.should be_a JSON::Any
      commit["id"].as_s.should eq "6104942438c14ec7bd21c6cd5bd995272b3faff6"
    end
  end

  describe ".commit_diff" do
    it "should return a diff of a commit" do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/diff", "project_commit_diff")
      diff = client.commit_diff(3, "6104942438c14ec7bd21c6cd5bd995272b3faff6")

      diff.should be_a JSON::Any
      diff["new_path"].as_s.should eq "doc/update/5.4-to-6.0.md"
    end
  end

  describe ".commit_comments" do
    it "should return commit's comments" do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/comments", "project_commit_comments")
      commit_comments = client.commit_comments(3, "6104942438c14ec7bd21c6cd5bd995272b3faff6")

      commit_comments.should be_a JSON::Any
      commit_comments.size.should eq(2)
      commit_comments[0]["note"].as_s.should eq "this is the 1st comment on commit 6104942438c14ec7bd21c6cd5bd995272b3faff6"
      commit_comments[0]["author"]["id"].as_i.should eq 11
      commit_comments[1]["note"].as_s.should eq "another discussion point on commit 6104942438c14ec7bd21c6cd5bd995272b3faff6"
      commit_comments[1]["author"]["id"].as_i.should eq 12
    end
  end

  describe ".create_commit_comment" do
    it "should return information about the newly created comment" do
      stub_post("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/comments", "project_commit_comment")
      merge_request = client.create_commit_comment(3, "6104942438c14ec7bd21c6cd5bd995272b3faff6", "Nice code!")

      merge_request.should be_a JSON::Any
      merge_request["note"].as_s.should eq "Nice code!"
      merge_request["author"]["id"].as_i.should eq 1
    end
  end

  describe ".commit_status" do
    it "should get statuses of a commit" do
      query = {"all" => "true"}
      stub_get("/projects/6/repository/commits/7d938cb8ac15788d71f4b67c035515a160ea76d8/statuses", "project_commit_status", query)
      statuses = client.commit_status(6, "7d938cb8ac15788d71f4b67c035515a160ea76d8", query)

      statuses.should be_a JSON::Any
      statuses[0]["sha"].as_s.should eq "7d938cb8ac15788d71f4b67c035515a160ea76d8"
      statuses[0]["ref"].as_s.should eq "decreased-spec"
      statuses[0]["status"].as_s.should eq "failed"
      statuses[-1]["sha"].as_s.should eq "7d938cb8ac15788d71f4b67c035515a160ea76d8"
      statuses[-1]["status"].as_s.should eq "success"
    end
  end

  describe ".update_commit_status" do
    it "should information about the newly created status" do
      form = {
        "state" => "failed",
        "name"  => "test",
        "ref"   => "decreased-spec",
      }
      stub_post("/projects/6/statuses/7d938cb8ac15788d71f4b67c035515a160ea76d8", "project_update_commit_status", form: form)
      status = client.update_commit_status(6, "7d938cb8ac15788d71f4b67c035515a160ea76d8", "failed", form)

      status.should be_a JSON::Any
      status["id"].as_i.should eq 498
      status["sha"].as_s.should eq "7d938cb8ac15788d71f4b67c035515a160ea76d8"
      status["status"].as_s.should eq "failed"
      status["ref"].as_s.should eq "decreased-spec"
    end
  end
end
