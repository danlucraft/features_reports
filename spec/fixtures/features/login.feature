Feature: Log in to the site
  As a user,
  I want to be able to log in to the site
  So I can access personalized features

  Scenario: Log in
    Given I have an account
    When I visit the login page
    And I enter my login details
    And I press "Login"
    Then I should be viewing my user page

  Scenario: Log in with bad password
    Given I have an account
    When I visit the login page
    And I enter my login details with a bad password
    And I press "Login"
    Then I should be viewing the login page
    And I should see the text "Bad username or password"

  Scenario: Log in with bad email
    Given I have an account
    When I visit the login page
    And I enter my login details with a bad email
    And I press "Login"
    Then I should be viewing the login page
    And I should see the text "Bad username or password"

  Scenario: Log in with bad password and then log in
    Given I have an account
    When I visit the login page
    And I enter my login details with a bad email
    And I press "Login"
    And I enter my login details
    And I press "Login"
    Then I should be viewing my user page
