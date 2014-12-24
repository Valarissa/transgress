require 'spec_helper'

describe Validator do
  before :each do
    @validator = Validator.new
    uri = "http://www.autostraddle.com"
    @content = Nokogiri::HTML(Request.get(uri)).root.content
    @content.encode!('UTF-8', 'UTF-8', :invalid => :replace)
  end

  describe "#new" do
    it "takes no parameters and returns a Validator object" do
      @validator.should be_an_instance_of Validator
    end

    it "regexes includes all safe and flagged terms" do
       current_count_of_safe_and_flagged_terms = 7
       regexps = Validator.regexes
       regexps.length.should eql current_count_of_safe_and_flagged_terms
    end
  end
end
