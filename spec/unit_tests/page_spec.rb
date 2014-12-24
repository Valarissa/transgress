require 'spec_helper'
require 'nokogiri'

describe Page do
  before :each do
    WebMock.allow_net_connect! 
    @page = Page.new "http://www.autostraddle.com"
  end

  describe "#new" do
    it "takes one parameter and returns a Page object" do
      @page.should be_an_instance_of Page
    end
  end
end
