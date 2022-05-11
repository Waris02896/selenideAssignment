@ignore
Feature: LockController api feature

  Background:
    * url serverUrl
    * def sleep =
      """
      function(seconds){
        for(i = 0; i <= seconds; i++)
        {
          java.lang.Thread.sleep(1*1000);
          karate.log(i);
        }
      }
      """
    * def RandomNumber =  function(){ return Math.random().toString().slice(2,11) }
    * def ExpErrorBody = {msg : '#string',code: '#string'}
    * def ExpSuccessBody = {lockId : '#string',lockExpiryMs: '#number',smilFile: '',lockCreationMs: '#number'}
    * def ExpErrorBodywithDeivces = {msg : '#string',code: '#string', devices: '#array'}
    * def ExpSuccessDelResponse =  {status : '#string'}
    * def ActID = 282756507
    * def DeviceGuid = 'yincnUaksfcjLSaTZN_hLC1lb9spyZx_'
    * def id = '100ea123-850a-4d66-8ea1-23850add66cb'

  @SuccessfulPostRequest
  Scenario: LockController Success response
    And print 1
    * def RN = RandomNumber()
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(RN)'}
    When method Post
    Then status 200
    And print response
    And match $.txRef == '#string'
    And match $.data != null
    And match response.data == ExpSuccessBody

  Scenario: LockController Invalid API key
    And print 2
    Given path '/v2/' + '123123231' + '/lock'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Post
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '8001'
    And match $.error.msg == 'invalid api key'
    And match response.error == ExpErrorBody

  Scenario: LockController Invalid Type
    And print 3
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live12'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Post
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9411'
    And match $.error.msg == 'invalid type'
    And match response.error == ExpErrorBody

  Scenario: LockController empty token
    And print 4
    Given path '/v2/' + appKey + '/lock'
    And header Authorication = ''
    And param type = 'live'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Post
    Then status 200
    #And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9004'
    And match $.error.msg == 'no token provided'
    And match response.error == ExpErrorBody

  Scenario: LockController GUID missing in body
    And print 5
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request {accountId: '#(ActID)'}
    When method Post
    Then status 200
    #And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9403'
    And match $.error.msg == 'deviceGuid is mandatory'
    And match response.error == ExpErrorBody

  Scenario: LockController Account Id Missing in body
    And print 6
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request {deviceGuid: '#(DeviceGuid)'}
    When method Post
    Then status 200
    #And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9404'
    And match $.error.msg == 'accountId is mandatory'
    And match response.error == ExpErrorBody

    @ignore @success
    Scenario: LockController Helper function
      And print 7.1
      Given path '/v2/' + appKey + '/lock'
      And param type = 'live'
      And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
      When method Post
      Then status 200

  Scenario: LockController another active
#    Uncomment below call to execute this scenario individually
#    * call sleep 10
    * def result = call read('LockController.feature@success')
    And print 7
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Post
    Then status 200
    #And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9408'
    And match $.error.msg == 'another active lock already exists for current device'
    And match response.error == ExpErrorBody

  Scenario: LockController Quota Reached
    And print 8
#    Uncomment below call to execute this scenario individually
#    * call sleep 10
#    * def result = call read('LockController.feature@SuccessResponse')
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request { deviceGuid: 'yincnUaksfcjLSaTZN_hLC1lbasdasd_' , accountId: '#(ActID)'}
    When method Post
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9405'
    And match $.error.msg == 'lock quota reached for the user'
    And match $.error.devices != null
    And match response.error == ExpErrorBodywithDeivces

  Scenario: LockController Smil file error
    And print 9
    Given path '/v2/' + appKey + '/lock'
    And header Authorization = '5v0DTxMc2w4wQ2XklCf4cYBoINBCUIAW'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request { deviceGuid: 'yincnUaksfcjLSaTZN_hLC1lb9spyZx_' , accountId: 282756507}
    When method Post
    Then status 200
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9002'
    And match $.error.msg == 'CANNOT PROCESS REQUEST'
    And match response.error == ExpErrorBody

  Scenario: LockController Success response without param
    And print 10
    * def RN = RandomNumber()
    Given path '/v2/' + appKey + '/lock'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(RN)'}
    When method Post
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.data != null
    And match $..lockId == '#array'
    And match $..lockCreationMs == '#array'
    And match $..lockExpiryMs == '#array'
    And match $..smilFile == '#array'
    And match response.data == ExpSuccessBody

  Scenario: LockController Success response with type and switch param
    And print 11
#    * call sleep 10
    * def RN = RandomNumber()
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And param switch = 'dash'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(RN)'}
    When method Post
    Then status 200
    And match $.txRef == '#string'
    And match $.data != null
    And match $..lockId == '#array'
    And match $..lockCreationMs == '#array'
    And match $..lockExpiryMs == '#array'
    And match $..smilFile == '#array'
    And match response.data == ExpSuccessBody

# Lock API Put cases

  @SuccessfulPutRequest
  Scenario: LockController Success response Put Request
    And print 12
#    * call sleep 10
    Given path '/v2/' + appKey + '/lock'
    * def RN = RandomNumber()
    And param type = 'live'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(RN)', lockId: '#(id)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match response.data == ExpSuccessBody

  Scenario: LockController Invalid API key Put Request
    And print 13
    Given path '/v2/' + '123123231' + '/lock'
    And param type = 'live'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '8001'
    And match $.error.msg == 'invalid api key'
    And match response.error == ExpErrorBody

  Scenario: LockController Invalid Type Put Request
    And print 14
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live12'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9411'
    And match $.error.msg == 'missing/invalid type'
    And match response.error == ExpErrorBody

  Scenario: LockController empty token Put Request
    And print 15
    Given path '/v2/' + appKey + '/lock'
    And header Authorication = ''
    And param type = 'live'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9004'
    And match $.error.msg == 'no token provided'
    And match response.error == ExpErrorBody

  Scenario: LockController empty token Put Request
    And print 16
    Given path '/v2/' + appKey + '/lock'
    And header Authorication = ''
    And param type = 'live'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9004'
    And match $.error.msg == 'no token provided'
    And match response.error == ExpErrorBody

  Scenario: LockController GUID missing in body Put Request
    And print 17
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request {accountId: '#(ActID)'}
    When method Put
    Then status 200
    #And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9403'
    And match $.error.msg == 'deviceGuid is mandatory'
    And match response.error == ExpErrorBody

  Scenario: LockController Account Id Missing in body Put Request
    And print 18
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request {deviceGuid: '#(DeviceGuid)'}
    When method Put
    Then status 200
    #And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9404'
    And match $.error.msg == 'accountId is mandatory'
    And match response.error == ExpErrorBody

  Scenario: LockController lockId is mandatory Put Request
    And print 19
    * def RN = RandomNumber()
    Given path '/v2/' + appKey + '/lock'
    And header Authorization = '5v0DTxMc2w4wQ2XklCf4cYBoINBCUIAW'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(RN)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9407'
    And match $.error.msg == 'lockId is mandatory'
    And match response.error == ExpErrorBody

  Scenario: LockController Smil file error Put Request
    And print 20
#    * call sleep 10
    * def result = call read('LockController.feature@put')
    Given path '/v2/' + appKey + '/lock'
    And header Authorization = '5v0DTxMc2w4wQ2XklCf4cYBoINBCUIAW'
    And param publicUrl = 'http://link.theplatform.eu/s/HLFsfC/AtmnM249JkuY'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)', lockId: '#(id)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9002'
    And match $.error.msg == 'CANNOT PROCESS REQUEST'
    And match response.error == ExpErrorBody

  Scenario: LockController Quota Reached Put Request
    And print 21
#    * call sleep 10
    * def result = call read('LockController.feature@SuccessfulDeleteRequest')
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request { deviceGuid: 'yincnUaksfcjLSaTZN_hLC1lbasdasd_' , accountId: '#(ActID)', lockId: '#(id)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9405'
    And match $.error.msg == 'lock quota reached for the user'
    And match $.error.devices != null
    And match response.error == ExpErrorBodywithDeivces

  Scenario: LockController another active Put Request
    And print 22
#    * call sleep 10
    * def result = call read('LockController.feature@SuccessfulDeleteRequest')
    Given path '/v2/' + appKey + '/lock'
    And param type = 'live'
    And request {deviceGuid: '#(DeviceGuid)' , accountId: '#(ActID)', lockId: '#(id)'}
    When method Put
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9408'
    And match $.error.msg == 'another active lock already exists for current device'
    And match response.error == ExpErrorBody

#    Delete Request Scenario

  @SuccessfulDeleteRequest
  Scenario: LockController Successful Delete Request
    And print 23
    Given path '/v2/' + appKey + '/lock'
    And params {lockId: '#(id)', accountId: '#(ActID)'}
    When method Delete
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $..status == '#array'
    And match response.data == ExpSuccessDelResponse

  Scenario: LockController Invalid API Key Delete Request
    And print 24
    Given path '/v2/' + '123546656' + '/lock'
    And params {lockId: '#(id)', accountId: '#(ActID)'}
    When method Delete
    Then status 200
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '8001'
    And match $.error.msg == 'invalid api key'
    And match response.error == ExpErrorBody

  Scenario: LockController LockId is mandatory Delete Request
    And print 25
    Given path '/v2/' + appKey + '/lock'
    And params {accountId: '#(ActID)'}
    When method Delete
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9407'
    And match $.error.msg == 'lockId is mandatory'
    And match response.error == ExpErrorBody

  Scenario: LockController AccountId is mandatory Delete Request
    And print 26
    Given path '/v2/' + appKey + '/lock'
    And params {lockId: '#(id)'}
    When method Delete
    Then status 200
#    And print response
    And match $.txRef == '#string'
    And match $.error == '#object'
    And match $.error.code == '9404'
    And param type = 'live'
    And match $.error.msg == 'accountId is mandatory'
    And match response.error == ExpErrorBody

  Below Cases need to add
    9009,9409,9406,1001