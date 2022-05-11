Feature: fetching User Details Contract driven testing


Background:
    * url serverUrl
    * def expectedoutput = read('Contract_A.json')

  Scenario: testing the get call for User Details

    Given path 'api/users/'
    When method GET
    Then status 200
    And print response
    And match response == expectedoutput