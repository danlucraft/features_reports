Feature: Sign up to the site
  As a visitor
  I want to be able to sign up for a user account
  So I can gain access to the personalized features of the site

  Scenario: Sign up
    When I visit the sign up page
    And I enter my sign up details with username "leoban"
    And I press "Sign up"
    Then I should be viewing the user page for user "leoban"

  Scenario: Sign up with missing email
    When I visit the sign up page
    And I enter my sign up details with username "leoban"
    And I forget to enter an email
    And I press "Sign up"
    Then I should be viewing the sign up page
    And I should see the text "email required"

  Scenario: Sign up with duplicate username
    Given there is a user with username "leoban"
    When I visit the sign up page
    And I enter my sign up details with username "leoban"
    And I press "Sign up"
    Then I should be viewing the sign up page
    And I should see the text "that username is already taken"

