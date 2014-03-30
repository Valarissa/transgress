Feature:  As a user
          I want this site to be easy to user
          So I can access what I need without technical knowledge

  Scenario: I enter a website in the site
    When I enter "http://www.trans-relephancy.com/"
    Then I am given a filtered version of the requested page

  Scenario: I enter a website without a protocol
    When I enter "www.trans-relephancy.com"
    Then I am given a filtered version of the requested page

  Scenario: The website I visit has links in the page
    When I enter "http://www.trans-relephancy.com/page"
    Then any links in the page are routed through transgress

  Scenario: The website I visit has a linked css stylesheet
    When I enter "www.trans-relephancy.com/page"
    Then any stylesheets in the page are routed through transgress

  Scenario: The website I visit has images
    When I enter "www.trans-relephancy.com/page"
    Then any images are routed through transgress

  Scenario: The website I visit has scripts
    When I enter "www.trans-relephancy.com/page"
    Then any scripts are routed through transgress
