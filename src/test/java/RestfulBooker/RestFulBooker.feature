@Running
Feature: Automate test scenarios of Restful-booker

  Background: Implement Authenticate
    * url 'https://restful-booker.herokuapp.com/'
    * header Accept = 'application/json'

  @authentication @Running
  Scenario: Implement Scenario for authentication
    Given path 'auth'
    And request {"username": "admin", "password": "password123"}
    When method POST
    Then status 200
    And match response.token == '#string'
    And print response.token

  Scenario:fetch booking ids via check-in/check-out query parameters
    Given path 'booking'
    And param checkin = 2014-03-13
    And param checkout = 2014-05-21
    When method GET
    Then status 200
    And assert response.length != null
    And print response

    Scenario Outline: Use booking ids from point2 to fetch booking details of each id
      Given path 'booking'
      And path id
      When method GET
      Then status 200
      And print response
      Examples:
      | id  |
      | 830 |
      | 723 |
      | 722 |
      | 724 |

#  @fetchIds
#  Scenario:fetch booking ids via check-in/check-out query parameters
#    Given path 'booking'
#    And param checkin = 2014-03-13
#    And param checkout = 2014-05-21
#    When method GET
#    Then status 200
#
#  @bookingidDetails
#  Scenario: fetch booking id details
#    * print arr
#    Given path 'booking/' + jsonResponse.bookingid
#    When method GET
#    Then status 200
#    And print response
#
#  Scenario:
#    * def jsonResponse = call read('RestFulBooker.feature@fetchIds')
#    * def jsonResponse = jsonResponse.response
#    * print jsonResponse
#    * def result = call read('RestFulBooker.feature@bookingidDetails') jsonResponse
#    * def created = $result[*].response
#    And print result

  Scenario:

  @createBooking
  Scenario: Create a new booking using URL encoded example
    Given path 'booking'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And form field firstname = 'Waris'
    And form field lastname = 'Ali'
    And form field totalprice = 200
    And form field depositpaid = true
    And form field bookingdates[checkin] = '2022-02-02'
    And form field bookingdates[checkout] = '2022-02-03'
    When method POST
    Then status 200
    And print response
    And match response.booking.firstname == 'Waris'
    And match response.booking.lastname == 'Ali'
    And match response.booking.depositpaid == true
    And match response.booking.totalprice == 200
    And match response.booking.bookingdates.checkin == '2022-02-02'
    And match response.booking.bookingdates.checkout == '2022-02-03'
    And print responseHeader


  Scenario: Update created booking. Authenticate user and extract token and update booking with authenttication token
    * def jsonResponse = call read('RestFulBooker.feature@createBooking')
    * def jsonResponse = jsonResponse.response
    * print jsonResponse
    Given path 'booking'
    And path jsonResponse.bookingid
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header Authorisation = 'Basic YWRtaW46cGFzc3dvcmQxMjM='
    And header Accept = 'application/x-www-form-urlencoded'
      And form field firstname = 'Waris'
      And form field lastname = 'Ghaffar'
      And form field totalprice = 111
      And form field depositpaid = true
      And form field bookingdates[checkin] = '2022-05-05'
      And form field bookingdates[checkout] = '2022-05-06'
      When method PUT
      Then status 200
      And print response

  Scenario: Delete Booking
    Given path 'booking'
    When method GET
    Then status 200
    And assert response.length != null
    And print response
    When path 'booking/1'
    And method Delete
    Then status 201
    And print Response