require 'spec_helper'

describe Validator do
  before :each do
    @validator = Validator.new
    uri = "http://www.autostraddle.com"
    @content = Nokogiri::HTML(Request.get(uri)).root.content
    @content.encode!('UTF-8', 'UTF-8', :invalid => :replace)

    @safe_terms = 5
    @flagged_terms = 2
    @redemption_terms = 2
  end

  describe "#new" do
    it "takes no parameters and returns a Validator object" do
      @validator.should be_an_instance_of Validator
    end

    it "regexes includes all safe and flagged terms" do
       current_count_of_safe_and_flagged_terms = @safe_terms + @flagged_terms
       regexps = Validator.regexes
       regexps.length.should eql current_count_of_safe_and_flagged_terms
    end

    it "safe regexes includes all safe terms" do
      regexps = Validator.safe_regexes
      regexps.length.should eql @safe_terms
    end

    it "flagged regexes includes all flagged terms" do
      regexps = Validator.flagged_regexes
      regexps.length.should eql @flagged_terms
    end

    it "redemption regexes includes all safe terms" do
      regexps = Validator.redemption_regexes
      regexps.length.should eql @redemption_terms
    end
  end
end
