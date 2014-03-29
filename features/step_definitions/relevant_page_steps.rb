When(/^I attempt to access a relevant page$/) do
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  FakeWeb.register_uri(:get, "http://www.trans-relephancy.com/", :body => f.read)
  visit('/visit/http%3A%2F%2Fwww.trans-relephancy.com%2F')
end

When(/^I enter "([^"]*)" into the text box$/) do |site_url|
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  FakeWeb.register_uri(:get, "http://www.trans-relephancy.com/", :body => f.read)
  visit('/visit/')
  fill_in "page", with: site_url
  click_on "transgress"
end

Then(/^I am given a filtered version of the requested page$/) do
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  page.body.should_not match(/this is irrelevant/i)
  page.body.should_not match(/\btrans\b/i)
end

Then(/^any links in the page are routed through transgress$/) do
  uri = URI(current_url)
  page.body.should_not match(/href="\/internal_link.html"/i)
  page.body.should match(/href="\/visit\/http%3A%2F%2Fwww.derp-relephancy.com%2Finternal_link.html"/)
end
