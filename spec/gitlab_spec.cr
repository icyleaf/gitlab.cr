require "./spec_helper"

describe Gitlab do
  describe "#client" do
    it "should initilize" do
      Gitlab.client("", "").should be_a Gitlab::Client
    end
  end
end
