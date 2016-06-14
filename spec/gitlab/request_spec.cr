require "../spec_helper"

describe Gitlab::Request do
  describe "#initilize" do
    it "should initilize" do
      Gitlab::Request.new("", "").should be_a Gitlab::Request
    end
  end

  describe "#exec" do
    pending "should request GET/POST/PUT/DELETE methods" do

    end
  end
end
