Feature: Put Request

  @Update_User
  Scenario: testing the put call for User Details

    Given url 'https://reqres.in/api/users/2'
    And request {'name': 'morpheus','job': 'leader'}
    When method Put
    Then status 200
#    And print response
    And match $.name == '#string'
    And match $.name == 'morpheus'
    And match $.job == 'leader'