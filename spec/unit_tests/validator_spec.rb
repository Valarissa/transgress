require 'spec_helper'

describe Validator do
  before :each do
    @validator = Validator.new
  end

  describe "#new" do
    it "takes no parameters and returns a Validator object" do
      @validator.should be_an_instance_of Validator
    end
  end
end
