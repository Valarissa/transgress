When(/^I attempt to access an irrelevant page$/) do
  f = File.open("#{File.dirname(__FILE__)}/../fixtures/irrelevant.html")
  FakeWeb.register_uri(:get, "http://www.irrelephant.com/", :body => f.read)
  visit('/visit/http%3A%2F%2Fwww.irrelephant.com%2F')
end

Then(/^I am told the page is not relevant$/) do
  expect(page.body).to match(/this is irrelevant/i)
end
