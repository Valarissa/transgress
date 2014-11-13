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
    expect(body).to_not have_content('this is irrelevant')
    expect(body).to_not have_content('trans')
  end
end

Then(/^any links in the page are routed through transgress$/) do
  expect(find(:css, "a[name='relative_link']")[:href]).to match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fpage%2Frelative_link.html")
  expect(find(:css, "a[name='absolute_link']")[:href]).to match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Finternal_link.html")
end

Then(/^any stylesheets in the page are routed through transgress$/) do
  expect(find(:css, "link[title='relative_css']", visible: false)[:href]).to match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fpage%2Frelative_css.css")
  expect(find(:css, "link[title='absolute_css']", visible: false)[:href]).to match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Finternal_css.css")
end

Then(/^any images are routed through transgress$/) do
  expect(find(:css, "img[name='relative_img']")[:src]).to match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fpage%2Frelative_img.jpg")
  expect(find(:css, "img[name='absolute_img']")[:src]).to match("/visit/http%3A%2F%2Fwww.trans-relephancy.com%2Fabsolute_img.jpg")
end

Then(/^any scripts are routed through transgress$/) do
  all(:css, 'script', visible: false).each do |s|
    expect(s[:src]).to_not match(/^\/absolute/)
    expect(s[:src]).to_not match(/^relative/)
  end
end
