Feature: fetching User Details

  Background:
    * def random_string =
 """
 function(s) {
   var text = "";
   var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
   for (var i = 0; i < s; i++)
     text += possible.charAt(Math.floor(Math.random() * possible.length));
   return text;
 }
 """
    * def sessionId =  random_string(5)



  @ignore @GetSpecificUser
  Scenario: testing the get call for User Details

    Given url 'https://reqres.in/api/users/'
    When method GET
    Then status 200
#    And print response
    * def Name = randomName
    * def Email = randomEmail
    * def data = response.data
    * def getUser =
    """
    function(arg){
    for(i=0;i<arg.length;i++){
      if(arg[i].id == 3){
         return arg[i]
          }
      }
    }
    """
    * def userDetail = call getUser data
    And print 'PRINT MY RESULT', userDetail
    And print 'PRINT MY RANDOM STRING', sessionId
    And print 'PRINT NAME FROM KARATE-CONFIG FILE', Name
    And print 'PRINT Email FROM KARATE-CONFIG FILE', Email