require 'spec_helper'

describe Genre do

  before(:each) do
    @name = double

    subject.stub(
      :name => @name
    )
  end

  describe "#to_s" do
    it "returns the titlecase name of the genre" do
      @name.should_receive(:titlecase)
      subject.to_s
    end
  end

end
