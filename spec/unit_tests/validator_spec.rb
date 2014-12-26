require 'spec_helper'

describe Validator do
  before :each do
    filename = Rails.root + 'public/assets/string_list.json'
    terms = JSON.parse(File.open(filename).read)

    @safe_terms = terms["safe"].count
    @flagged_terms = terms["flagged"].count
    @redemption_terms = terms["redemption"].count

    @validator = Validator.new
  end

  describe "#new" do
    it "takes no parameters and returns a Validator object" do
      @validator.should be_an_instance_of Validator
    end
  end

  describe "#regexes" do
    it "regexes includes all safe and flagged terms" do
       current_count_of_safe_and_flagged_terms = @safe_terms + @flagged_terms
       regexps = Validator.regexes
       regexps.length.should eql current_count_of_safe_and_flagged_terms
    end
  end

  describe "#safe_regexes" do
    it "safe regexes includes all safe terms" do
      regexps = Validator.safe_regexes
      regexps.length.should eql @safe_terms
    end
  end

  describe "#flagged_regexes" do
    it "flagged regexes includes all flagged terms" do
      regexps = Validator.flagged_regexes
      regexps.length.should eql @flagged_terms
    end
  end

  describe "#redemption_regexes" do
    it "redemption regexes includes all safe terms" do
      regexps = Validator.redemption_regexes
      regexps.length.should eql @redemption_terms
    end
  end

  describe "#check_no_flagged_terms" do
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

  describe "#validate" do
    it "validate returns true if content is valid" do
      uri = "http://www.autostraddle.com"

      stub_request(:any, uri)
      .to_return(:body => "This content is about transgender issues.",
      :status => 200)

      document = Nokogiri::HTML(Request.get(uri))

      bool = Validator.validate(document)

      bool.should eql true
    end

    it "validate returns false if content is not valid" do
      uri = "http://www.autostraddle.com"

      stub_request(:any, uri)
      .to_return(:body => "This content uses messed-up terms like shemale.",
      :status => 200)

      document = Nokogiri::HTML(Request.get(uri))

      bool = Validator.validate(document)

      bool.should eql false
    end

    it "validate returns true if content is redeemed" do
      uri = "http://www.autostraddle.com"

      stub_request(:any, uri)
      .to_return(:body => "This content understands a term like shemale is a
        slur.",
      :status => 200)

      document = Nokogiri::HTML(Request.get(uri))

      bool = Validator.validate(document)

      bool.should eql true
    end
  end
end
