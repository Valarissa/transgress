require 'spec_helper'

describe Validator do
  before :each do
    @safe_terms = 5
    @flagged_terms = 2
    @redemption_terms = 2

    @validator = Validator.new
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

    it "check no flagged terms returns true if content is not flagged" do
      uri = "http://www.autostraddle.com"

      stub_request(:any, uri)
        .to_return(:body => "This content about trans issues is okay.",
        :status => 200)

      content = Nokogiri::HTML(Request.get(uri)).root.content
      content.encode!('UTF-8', 'UTF-8', :invalid => :replace)

      bool = Validator.check_no_flagged_terms(content)
      bool.should eql true
    end

    it "check no flagged terms returns false if content is flagged" do
      uri = "http://www.autostraddle.com"

      stub_request(:any, uri)
      .to_return(:body => "This content about tranny stuff isn't okay.",
      :status => 200)

      content = Nokogiri::HTML(Request.get(uri)).root.content
      content.encode!('UTF-8', 'UTF-8', :invalid => :replace)

      bool = Validator.check_no_flagged_terms(content)
      bool.should eql false
    end

    it "check no flagged terms returns true if content is flagged & redeemed" do
      uri = "http://www.autostraddle.com"

      stub_request(:any, uri)
      .to_return(:body => "This content understands tranny is a slur.",
      :status => 200)

      content = Nokogiri::HTML(Request.get(uri)).root.content
      content.encode!('UTF-8', 'UTF-8', :invalid => :replace)

      bool = Validator.check_no_flagged_terms(content)
      bool.should eql true
    end
  end
end
