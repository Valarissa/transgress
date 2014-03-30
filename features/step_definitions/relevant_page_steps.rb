When(/^I attempt to access a relevant page$/) do
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  FakeWeb.register_uri(:get, "http://www.trans-relephancy.com/", :body => f.read)
  visit('/visit/http%3A%2F%2Fwww.trans-relephancy.com%2F')
end

When(/^I enter "([^"]*)"$/) do |site_url|
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  FakeWeb.register_uri(:get, "http://www.trans-relephancy.com/", :body => f.read)
  visit('/visit/')
  fill_in "page", with: site_url
  click_on "transgress"
end

Then(/^I am given a filtered version of the requested page$/) do
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  within('//body') do |body|
    body.should_not have_content('this is irrelevant')
    body.should_not have_content('trans')
  end
end

Then(/^any links in the page are routed through transgress$/) do
  all('a').each do |a|
    a[:href].should_not match("/internal_link.html")
    a[:href].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Finternal_link.html")
  end
end

Then(/^any stylesheets in the page are routed through transgress$/) do
  all('link').each do |l|
    l[:href].should_not match("/internal_css.css")
    l[:href].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Finternal_css.css")
  end
end
