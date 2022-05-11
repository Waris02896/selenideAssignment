Feature: fetching User Details Contract driven testing with B

Background:
    * url serverUrl
    * def expectedoutput = read('Contract_B.json')

  Scenario: testing the get call for User Details

    Given path 'api/users/'
    When method GET
    Then status 200
    And print response
    And match response.support == expectedoutput