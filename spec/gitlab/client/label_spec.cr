require "../../spec_helper"

describe Gitlab::Client::Label do
  describe ".labels" do
    it "should return a paginated response of project's labels" do
      stub_get("/projects/3/labels", "labels")
      labels = client.labels(3)

      labels.should be_a JSON::Any
      labels[0]["name"].as_s.should eq "Backlog"
    end
  end

  describe ".delete" do
    it "should return information about a deleted snippet" do
      stub_delete("/projects/3/labels", "label")
      label = client.delete_label(3, "Backlog")
      label.should be_a(JSON::Any)

      label.as(JSON::Any)["name"].as_s.should eq "Backlog"
    end

    it "should return true since 9.0" do
      result = stub_delete("/projects/4/labels")
      result = client.delete_label(4, "Backlog")
      result.should be_true
    end
  end

  describe ".edit_label" do
    it "should return information about an edited label" do
      form = {"name" => "TODO", "new_name" => "Backlog"}
      stub_put("/projects/3/labels", "label", form: form)
      label = client.edit_label(3, "TODO", form)

      label["name"].as_s.should eq "Backlog"
    end
  end

  describe ".create_label" do
    it "should return information about a created label" do
      stub_post("/projects/3/labels", "label")
      label = client.create_label(3, "Backlog", "#DD10AA")

      label["name"].as_s.should eq "Backlog"
      label["color"].as_s.should eq "#DD10AA"
    end
  end

  describe ".subscribe_label" do
    it "should return information about the label subscribed to" do
      stub_post("/projects/3/labels/Backlog/subscribe", "label")
      label = client.subscribe_label(3, "Backlog")

      label["name"].as_s.should eq "Backlog"
      label["subscribed"].as_bool.should be_truthy
    end
  end

  describe ".unsubscribe_label" do
    it "should return information about the label subscribed to" do
      stub_post("/projects/3/labels/Backlog/unsubscribe", "label_unsubscribe")
      label = client.unsubscribe_label(3, "Backlog")

      label["name"].as_s.should eq "Backlog"
      label["subscribed"].as_bool.should be_falsey
    end
  end
end
