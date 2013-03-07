@javascript

Feature: Autotest API
  Background:
    Given I go to home page
    And I wait for 1 seconds

  Scenario: Create New Item, next page, select show 25 items per page
    When I press the button "btn-new"
    And I fill in "new_item_name" with "Shaton"
    And I fill in "new_item_description" with "Hello World"
    And I wait for 1 seconds
    When I press the button "new_item_save"
    Then I should see "Shaton"
    And I wait for 1 seconds
    And I press the button "btn-new"
    And I fill in "new_item_name" with "Hello A"
    And I fill in "new_item_description" with "Hello World"
    And I wait for 1 seconds
    When I press the button "new_item_save"
    Then I should see "First"
    And I click "Next" span
    Then I should see "Hello A"
    And I wait for 1 seconds
    And I select "25" from "promotions-per-page"
    And I wait for 1 seconds
    Then I should see "Hello A" and should not see "First"

  Scenario: Delete Item
    When I click the row "#proid-1 input"
    And I press the button "btn-delete"
    And I press the button "popup_ok"
    Then I should not see "Hello"
    And I wait for 1 seconds

  Scenario: Get Item from Server
    When I press the button "btn-get"
    And I wait for 2 seconds
    Then I should see "Shaton"
    And I wait for 1 seconds

  Scenario: Search item
    When I fill in "promo-search" with "1"
    And I click the div ".btn-search"
    And I wait for 2 seconds
    Then I should see "Hello"
    And I wait for 1 seconds
