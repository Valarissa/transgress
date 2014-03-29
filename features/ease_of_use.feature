Feature:  As a user
          I want this site to be easy to user
          So I can access what I need without technical knowledge

Scenario: I enter a website in the site
    When I enter "http://www.trans-relephancy.com/" into the text box
    Then I am given a filtered version of the requested page

Scenario: The website I visit has links in the page
    When I enter "http://www.trans-relephancy.com/" into the text box
    Then any links in the page are routed through transgress
