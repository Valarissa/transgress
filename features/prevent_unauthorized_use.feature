Feature:  As a site administrator
          I want to be able to prevent unauthorized use
          To prevent being flagged by content filters

Scenario: Attempting to access a site that does not have relevant information
    When I attempt to access an irrelevant page
    Then I am told the page is not relevant

Scenario: Attempting to access a site relevant to trans issues
    When I attempt to access a relevant page
    Then I am given a filtered version of the requested page
