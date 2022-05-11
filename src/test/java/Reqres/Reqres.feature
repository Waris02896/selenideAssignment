Feature: Test suite for Reqres.in APIs automation

  Background:
    * url 'https://reqres.in/api/'

  @Question2
  Scenario: Get all users on page 20
    Given path 'users?per_page=20'
    When method GET
    Then status 200
    And print response

  @Question2
  Scenario: Get single user id 2
    Given path 'users/2'
    When method GET
    Then status 200
    And print response

  @Question2
  Scenario: User not found
    Given path '/api/users/23'
    When method GET
    Then status 404
    And print response

  @Question2
  Scenario: List of Users
    Given path 'unknown'
    When method GET
    Then status 200
    And print response

  @Question2
  Scenario: Single user
    Given path 'unknown/2'
    When method GET
    Then status 200
    And print response

  @Question2
  Scenario: User not found
    Given path 'unknown/23'
    When method GET
    Then status 404
    And print response

  @Question2
  Scenario: Create user
    Given path 'users'
    And request {"name": "Waris", "job": "QA Engineer"}
    When method POST
    Then status 201
    And print response

  @Question2
  Scenario: Update user by PUT
    Given path 'users'
    And path '2'
    And request {"name": "norpheus", "job": "zion resident"}
    When method PUT
    Then status 200
    And print response

  @Question2
  Scenario: Update user by Patch
    Given path 'users'
    And path '2'
    And request {"name": "norpheus", "job": "zion resident"}
    When method PATCH
    Then status 200
    And print response

  @Question2
  Scenario: Delete user
    Given path 'users/2'
    When method DELETE
    Then status 204
    And print response

  @Question2
  Scenario: User register successfull
    Given path 'register'
    And request {"email": "eve.holt@reqres.in", "password": "waris123"}
    When method POST
    Then status 200
    And print response

  @Question2
  Scenario: User register unsuccessfull
    Given path 'register'
    And request {"email": "eve.holt@reqres.in"}
    When method POST
    Then status 400
    And print response
    And match response.error == "Missing password"

  @Question2
  Scenario: User login successfull
    Given path 'login'
    And request {"email": "eve.holt@reqres.in", "password": "cityslicka"}
    When method POST
    Then status 200
    And print response

  @Question2
  Scenario: User login unsuccessfull
    Given path 'login'
    And request {"email": "eve.holt@reqres.in"}
    When method POST
    Then status 400
    And print response
    And match response.error == "Missing password"

  Scenario: Deplayed response
    Given path 'users'
    And param delay = '3'
    When method GET
    Then status 200
    And print response

#  @userDetails
#  Scenario: Get user details
#    Given path 'users'
#    And path #(id)
#    When method GET
#    Then 200
#    And print response

  @Question3
  Scenario Outline: Select ids from user list and get details of each id
    Given path 'users'
    And path id
    When method GET
    Then status 200
    And print response
    Examples:
      | id |
      | 8  |
      | 9  |
      | 10 |
      | 11 |
      | 12 |

  @Question4
  Scenario Outline: Select ids from user list and get details of each id
    Given path 'users'
    And path id
    When method DELETE
    And print response
    Examples:
      | id |
      | 8  |
      | 9  |
      | 10 |
      | 11 |
      | 12 |