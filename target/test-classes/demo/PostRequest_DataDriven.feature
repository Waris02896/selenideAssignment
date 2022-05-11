Feature: Post Request data driven

  Scenario Outline: testing the post call for User Details

    Given url 'https://reqres.in/api/users'
    And request {'name': <Name>,'job': <Job>}
    When method POST
    Then status 201
    And print response

    Examples:
      | Name          | Job
      | 'QA Engineer' | 'SQA'
      | 'Junior QA'   | 'Jr. SQA'
