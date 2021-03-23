require "../../spec_helper"

describe Gitlab::Client::RepositoryFile do
  describe "get_file" do
    pending { "TODO" }
  end

  describe "file_contents" do
    pending { "TODO" }
  end

  describe "create_file" do
    it "should create file in repository" do
      stub_post("/projects/2/repository/files/path", "repository_file")
      client.create_file(2, "path", "branch", "Y29udGVudA==", "commit_message")
    end
  end

  describe "file_contents_from_blobs" do
    pending { "TODO" }
  end

  describe "file_contents_from_files" do
    pending { "TODO" }
  end
end
