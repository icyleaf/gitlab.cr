require "../spec_helper"

describe Gitlab::Client do
  describe "#client" do
    it "should initilize" do
      Gitlab::Client.new("", "").should be_a Gitlab::Client
    end
  end
end
