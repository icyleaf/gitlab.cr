require "../spec_helper"

Spec2.describe Gitlab::Client do
  describe "#client" do
    it "should initilize" do
      expect(Gitlab::Client.new("", "")).to be_a Gitlab::Client
    end
  end
end
