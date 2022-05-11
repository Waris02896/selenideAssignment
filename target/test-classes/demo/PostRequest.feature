Feature: Post Request

  Scenario: testing the post call for User Details

    Given url 'https://reqres.in/api/users'
    And request {'name': 'morpheus','job': 'leader'}
    When method POST
    Then status 201
    And print response
    And match $.name == '#string'
    And match $.job == 'leader'
    And match $.id == '#string'