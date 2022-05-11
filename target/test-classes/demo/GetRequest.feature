Feature: fetching User Details

  Scenario: testing the get call for User Details

    Given url 'https://reqres.in/api/users/2'
    When method GET
    Then status 200
    And print 'Cursor is in Get Request', response
    And match $.data.last_name == '#string'
    And match $.data.last_name == 'Weaver'
    And match $.data.id == '#number'
    And match $.data.avatar == '#string'
    And match $.data.first_name == '#string'
    And match $.data.email == '#string'
    And match $.data.avatar == '#string'