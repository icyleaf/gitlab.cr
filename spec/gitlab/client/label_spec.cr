require "../../spec_helper"

Spec2.describe Gitlab::Client::Label do
  describe ".labels" do
    it "should return a paginated response of project's labels" do
      stub_get("/projects/3/labels", "labels")
      labels = client.labels(3)

      expect(labels).to be_a JSON::Any
      expect(labels[0]["name"].as_s).to eq "Backlog"
    end
  end

  describe ".delete" do
    it "should return information about a deleted snippet" do
      stub_delete("/projects/3/labels", "label")
      label = client.delete_label(3, "Backlog")

      expect(label["name"].as_s).to eq "Backlog"
    end
  end

  describe ".edit_label" do
    it "should return information about an edited label" do
      form = { "name" => "TODO", "new_name" => "Backlog"}
      stub_put("/projects/3/labels", "label", form: form)
      label = client.edit_label(3, "TODO", form)

      expect(label["name"].as_s).to eq "Backlog"
    end
  end

  describe ".create_label" do
    it "should return information about a created label" do
      stub_post("/projects/3/labels", "label")
      label = client.create_label(3, "Backlog", "#DD10AA")

      expect(label["name"].as_s).to eq "Backlog"
      expect(label["color"].as_s).to eq "#DD10AA"
    end
  end

  describe ".subscribe_label" do
    it "should return information about the label subscribed to" do
      stub_post("/projects/3/labels/Backlog/subscribe", "label")
      label = client.subscribe_label(3, "Backlog")
      pp label

      expect(label["name"].as_s).to eq "Backlog"
      expect(label["subscribed"].as_bool).to be_truthy
    end
  end

  describe ".unsubscribe_label" do
    it "should return information about the label subscribed to" do
      stub_post("/projects/3/labels/Backlog/unsubscribe", "label_unsubscribe")
      label = client.unsubscribe_label(3, "Backlog")

      expect(label["name"].as_s).to eq "Backlog"
      expect(label["subscribed"].as_bool).to be_falsey
    end
  end
end
