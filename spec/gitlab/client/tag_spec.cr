require "../../spec_helper"

describe Gitlab::Client::Tag do
  describe ".tags" do
    it "should return a paginated response of repository tags" do
      stub_get("/projects/3/repository/tags", "project_tags")
      tags = client.tags(3)

      tags.should be_a JSON::Any
      tags[0]["name"].as_s.should eq "v2.8.2"
    end
  end

  describe ".tag" do
    it "should return information about repository tag" do
      stub_get("/projects/3/repository/tags/v1.0.0", "project_tag_lightweight")
      tags = client.tag(3, "v1.0.0")

      tags.should be_a JSON::Any
      tags["name"].as_s.should eq "v1.0.0"
    end
  end

  describe ".create_tag" do
    context "when lightweight" do
      it "should return information about a new repository tag" do
        stub_post("/projects/3/repository/tags", "project_tag_lightweight")
        tag = client.create_tag(3, "v1.0.0", "2695effb5807a22ff3d138d593fd856244e155e7")

        tag["name"].as_s.should eq "v1.0.0"
        tag["message"].as_nil.should eq nil
      end
    end

    context "when annotated" do
      it "should return information about a new repository tag" do
        WebMock.reset
        form = {
          "tag_name" => "v1.10",
          "ref"      => "2695effb5807a22ff3d138d593fd856244e155e7",
          "message"  => "Release 1.1.0",
        }
        stub_post("/projects/3/repository/tags", "project_tag_annotated", form: form)
        tag = client.create_tag(3, "v1.1.0", "2695effb5807a22ff3d138d593fd856244e155e7", form)

        tag["name"].as_s.should eq "v1.1.0"
        tag["message"].as_s.should eq "Release 1.1.0"
      end
    end
  end

  describe ".delete_tag" do
    it "should return information about a deleted tag" do
      stub_delete("/projects/3/repository/tag/v1.0.0", "project_tag_lightweight")
      tag = client.delete_tag(3, "v1.0.0")

      tag["name"].as_s.should eq "v1.0.0"
    end
  end

  describe ".create_release_notes" do
    pending { "TODO" }
  end

  describe ".update_release_notes" do
    pending { "TODO" }
  end
end
