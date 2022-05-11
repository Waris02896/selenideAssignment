Feature: Heartbeat with version

Background:
    * url serverUrl

Scenario:
    Given path 'api/users/2'
    When method GET
    Then status 200
    And print response
#    And match $.txRef == '#string'
#    And match $.data.code == '200'
#    And match $.data.description contains 'lub dub, jar_v: 0.1.0, tag:'