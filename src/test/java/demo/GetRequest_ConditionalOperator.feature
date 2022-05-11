Feature: fetching User Details

  Scenario: testing the get call for User Details

    Given url 'https://reqres.in/api/users/2'
    When method GET
    Then status 200
    And print response
    * def Username = response.data.first_name
    * def callNext = Username == 'Jannet' ? karate.call('Common.feature') : karate.call('GetRequest.feature')
    And print Username