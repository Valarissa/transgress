When(/^I attempt to access a relevant page$/) do
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  FakeWeb.register_uri(:get, "http://www.trans-relephancy.com/", :body => f.read)
  visit('/visit/http%3A%2F%2Fwww.trans-relephancy.com%2F')
end

When(/^I enter "([^"]*)"$/) do |site_url|
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/relevant.html")
  FakeWeb.register_uri(:get, Page.fill_in_url_details(site_url), :body => f.read)
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
  find(:css, "a[name='relative_link']")[:href].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fpage%2Frelative_link.html")
  find(:css, "a[name='absolute_link']")[:href].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Finternal_link.html")
end

Then(/^any stylesheets in the page are routed through transgress$/) do
  find(:css, "link[name='relative_css']")[:href].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fpage%2Frelative_css.css")
  find(:css, "link[name='absolute_css']")[:href].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Finternal_css.css")
end

Then(/^any images are routed through transgress$/) do
  find(:css, "img[name='relative_img']")[:src].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fpage%2Frelative_img.jpg")
  find(:css, "img[name='absolute_img']")[:src].should match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fabsolute_img.jpg")
end
