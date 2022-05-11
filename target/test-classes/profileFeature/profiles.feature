@ignore
Feature: Profile

Background:
    * url serverUrl
    * def SuccessDataResponse = {parentalControl: '#string'}
    * def Token = 'GDMSTGExy0sVDlZMzNDdUyZ'
    * def User = 'multiprofile@mailinator.com'
    * def result = call read('common.feature@user_token')
    * def encPass = 'MTU4Nzg5Mzg5NjAwMDoxMjM0NTY='
    * def epoch = '1587893896000'
    * def SuccessResponse =  {profilesLimit: '#number', profiles: '#array', prev:'#number'}
    * def SuccessfulPostResponse = {"profileName":'#string',"default":false,"defaultSubTitleLang":"en","profileGuid":'#string',"autoPlayNextEpisode":true,"parentalControl":"R18","passwordProtected":false,"defaultAudioLang":"en","avatar":"#9D5CDD","updatedOn":'#number',"createdOn":'#number'}
    * def SuccessfulPutResponse = {"profileName": "profile-2","default": false,"defaultSubTitleLang": "ar","profileGuid": '#string',"autoPlayNextEpisode": false,"parentalControl": "PG18","passwordProtected": true,"defaultAudioLang": "ar","updatedOn": '#number',"createdOn": '#number'}
    * def errorresponse = {"txRef": '#string',"error": {"msg": '#string',"code": '#string'}}
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
    * def ProfileName = random_string(5)


#    Get Profile Test cases

Scenario: Successful Profile Response
    Given path 'profiles/v3/' + Token +'/users/'+ User +'/profiles'
    * header Authorization = result.response.data.authToken
    When method GET
    Then status 200
    And match $.txRef == '#string'
    And match $.data.profilesLimit == 5
    And print response
    And match $.data.profiles == '#array'
    And match $.data.prev == '#number'
    And match $.data == SuccessResponse

    Scenario: Invalid or expired token
        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profiles'
        * header Authorization = 'test@gmail.com'
        When method GET
        Then status 200
        And match $.txRef == '#string'
#        And print response
        And match $.error.msg == "invalid or expired token"
        And match $.error.code == '9006'
        And match response == errorresponse

    Scenario: No Token Provided
        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profiles'
        When method GET
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == '9004'
        And match $.error.msg == 'no token provided'
        And match response == errorresponse

    Scenario: Invalid API Key
        Given path 'profiles/v3/' + 1232131231 +'/users/'+ User +'/profiles'
        * header Authorization = result.response.data.authToken
        When method GET
        Then status 200
#    And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == '8001'
        And match $.error.msg == 'invalid api key'
        And match response == errorresponse

    Scenario: Invalid token for user
        Given path 'profiles/v3/'+ Token +'/users/test/profiles'
        * header Authorization = result.response.data.authToken
        When method GET
        Then status 200
#    And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == '6003'
        And match $.error.msg == "token doesn't belong to the provided username"
        And match response == errorresponse

#            DELETE profile
    Scenario: Delete Profile Successful
        * def addprofile = call read('common.feature@Add_profile')
        * def getSecondprofile = call read('common.feature@GetProfilesIndex')
        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + getSecondprofile.item.profileGuid
#        * def GetPro = call read('common.feature@GetProfiles')
        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
        When method Delete
        Then status 200
        And match $.txRef == '#string'
        And match $.data.status == "accepted"
        * def addprofile = call read('common.feature@Add_profile')

    Scenario: Delete Profile without token
        * def addprofile = call read('common.feature@Add_profile')
        * def getSecondprofile = call read('common.feature@GetProfilesIndex')
        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + getSecondprofile.item.profileGuid
#       * headers {encPassword: encPass, epochMs: epoch}
        When method Delete
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == '9004'
        And match $.error.msg == "no token provided"
        And match response == errorresponse
#    @ignore
    Scenario: Delete Profile Invalid Guid
        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile/1212121'
        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
        When method Delete
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == '9026'
        And match $.error.msg == "invalid profile guid"
        And match response == errorresponse
#    @ignore
    Scenario: Delete Profile Token belong to other user
        * def addprofile = call read('common.feature@Add_profile')
        * def getSecondprofile = call read('common.feature@GetProfilesIndex')
        Given path 'profiles/v3/' + Token +'/users/test/profile/' + getSecondprofile.item.profileGuid
       And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
        When method Delete
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == '6003'
        And match $.error.msg == "token doesn't belong to the provided username"
        And match response == errorresponse
#    @ignore
    Scenario: Delete Profile Invalid API key
        * def GetProfiles = call read('common.feature@GetProfiles')
        Given path 'profiles/v3/12121212/users/test@mailinator.com/profile/' + GetProfiles.ProfileName.profileGuid
        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
        When method Delete
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == '8001'
        And match $.error.msg == "invalid api key"
        And match response == errorresponse

#        Post profile
#    @ignore
    Scenario: Post Add User Profile
        * def res = call read('common.feature@Deleteforpost')
        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
        * headers {Authorization : '#(result.response.data.authToken)'}
        And request {'profileName': " #(ProfileName)",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.data == SuccessfulPostResponse
#    @ignore
#    Scenario: POST Add duplicate profile
#        * def res12 = call read('common.feature@Add_profile')
#        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
#        * headers {Authorization : '#(result.response.data.authToken)'}
#        And request {'profileName': "profile-2",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
#        When method Post
#        Then status 200
##        And print response
#        And match $.txRef == '#string'
#        And match $.error == '#object'
#        And match $.error.code == "9024"
#        And match $.error.msg == "profile already exists"
#        And match response == errorresponse
##    @ignore
    Scenario: POST Token belong to other user
        * def res = call read('common.feature@Add_profile')
        Given path 'profiles/v3/'+ Token +'/users/test/profile'
        * headers {Authorization : '#(result.response.data.authToken)'}
        And request {'profileName': "profile-2",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == "6003"
        And match $.error.msg == "token doesn't belong to the provided username"
        And match response == errorresponse
#    @ignore
    Scenario: POST Invalid API key
        * def res = call read('common.feature@Add_profile')
        Given path 'profiles/v3/12121212/users/'+ User +'/profile'
        * headers {Authorization : '#(result.response.data.authToken)'}
        And request {'profileName': "profile-2",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == "8001"
        And match $.error.msg == "invalid api key"
        And match response == errorresponse
#    @ignore
    Scenario: Post no token provided
        * def res = call read('common.feature@DeleteProfile')
        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
        And request {'profileName': "profile-2",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == "9004"
        And match $.error.msg == "no token provided"
        And match response == errorresponse

#        @ignore
    Scenario: Post Add User Profile duplicate
        * def res = call read('common.feature@DeleteProfile')
        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
        * headers {Authorization : '#(result.response.data.authToken)'}
        And request {'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == "9005"
        And match $.error.msg == "invalid profile name"
        And match response == errorresponse
#    @ignore
    Scenario: Post Invalid Request Body
        * def res = call read('common.feature@DeleteProfile')
        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
        * headers {Authorization : '#(result.response.data.authToken)'}
        And request {'profileName': "profile-2",'profileSettings': {}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == "1001"
        And match $.error.msg == "Invalid request body"
        And match response == errorresponse

#    @ignore
    Scenario: Post Add default profile
        * def res = call read('common.feature@DeleteProfile')
        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
        * headers {Authorization : '#(result.response.data.authToken)'}
        And request {'profileName': "default",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == "9032"
        And match $.error.msg == "profile name 'default' is reserved only for default profile"
        And match response == errorresponse

#        @ignore
    Scenario: Post Add profile limit reached
        * def fun = function(x){ return { count: x } }
        * def data = karate.repeat(4, fun)
        * call read('common.feature@AddMultipleProfiles') data
        Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
        * headers {Authorization : '#(result.response.data.authToken)'}
        And request {'profileName': "profile-limit",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
        When method Post
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error == '#object'
        And match $.error.code == "8080"
        And match $.error.msg == "profile creation limit reached"
        And match response == errorresponse

##        Put Profile
    @ignore
    Scenario: Update Profile Successful
        * def GetProfilesRes = call read('common.feature@Add_profileforupdate')
        * def GetProfiles = call read('common.feature@GetProfiles')
        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + GetProfiles.ProfileName.profileGuid
        And request {'profileName': 'profile-2','profileSettings': {'parentalControl': 'PG18','defaultAudioLang': 'ar','passwordProtected': true,'defaultSubTitleLang': 'ar','autoPlayNextEpisode': false}}
        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
        When method Put
#        And print GetProfiles.ProfileName.profileGuid
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.data == SuccessfulPutResponse
#
        @ignore
    Scenario: Update Profile without token
        * def GetProfilesRes = call read('common.feature@Add_profile')
        * def GetProfiles = call read('common.feature@GetProfiles')
        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + GetProfiles.ProfileName.profileGuid
        And request {'profileName': 'profile-2','profileSettings': {'parentalControl': 'PG18','defaultAudioLang': 'ar','passwordProtected': true,'defaultSubTitleLang': 'ar','autoPlayNextEpisode': false}}
        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000}
        When method Put
        Then status 200
#        And print response
        And match $.txRef == '#string'
        And match $.error.msg == "no token provided"
        And match $.error.code == "9004"
        And match response == errorresponse
##
##            @ignore
#    Scenario: Update Profile Missing/Invalid Password
#        * def GetProfilesRes = call read('common.feature@Add_profile')
#        * def resp = call read('common.feature@GetProfiles')
#        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + resp.ProfileName.profileGuid
#        And request {'profileName': 'profile-2','profileSettings': {'parentalControl': 'PG18','defaultAudioLang': 'ar','passwordProtected': true,'defaultSubTitleLang': 'ar','autoPlayNextEpisode': false}}
#        And headers {Authorization : '#(result.response.data.authToken)'}
#        When method Put
#        And print 'My Guid : ' + resp.ProfileName.profileGuid
#        Then status 200
##        And print response
#        And match $.txRef == '#string'
#        And match $.error.msg == "missing/invalid password"
#        And match $.error.code == "9028"
#        And match response == errorresponse
##
##                @ignore
#    Scenario: Update Profile missing epoch header
#        * def GetProfilesRes = call read('common.feature@Add_profile')
#        * def GetProfiles = call read('common.feature@GetProfiles')
#        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + ProfileName.profileGuid
#        And request {'profileName': 'profile-2','profileSettings': {'parentalControl': 'PG18','defaultAudioLang': 'ar','passwordProtected': true,'defaultSubTitleLang': 'ar','autoPlayNextEpisode': false}}
#        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, Authorization : '#(result.response.data.authToken)'}
#        When method Put
#        Then status 200
##        And print response
#        And match $.txRef == '#string'
#        And match $.error.msg == "missing epoch header"
#        And match $.error.code == "9029"
#        And match response == errorresponse
##
##        @ignore
#    Scenario: Update Profile invalid api key
#        * def GetProfilesRes = call read('common.feature@Add_profile')
#        * def GetProfiles = call read('common.feature@GetProfiles')
#        Given path 'profiles/v3/12221212/users/'+ User +'/profile/' + GetProfiles.ProfileName.profileGuid
#        And request {'profileName': 'profile-2','profileSettings': {'parentalControl': 'PG18','defaultAudioLang': 'ar','passwordProtected': true,'defaultSubTitleLang': 'ar','autoPlayNextEpisode': false}}
#        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
#        When method Put
#        Then status 200
#        And match $.txRef == '#string'
#        And match $.error.msg == "invalid api key"
#        And match $.error.code == "8001"
#        And match response == errorresponse
##
##        @ignore
#    Scenario: Update Profile token belong to other user
#        * def GetProfilesRes = call read('common.feature@Add_profile')
#        * def GetProfiles = call read('common.feature@GetProfiles')
#        Given path 'profiles/v3/' + Token +'/users/test/profile/' + GetProfiles.ProfileName.profileGuid
#        And request {'profileName': 'profile-2','profileSettings': {'parentalControl': 'PG18','defaultAudioLang': 'ar','passwordProtected': true,'defaultSubTitleLang': 'ar','autoPlayNextEpisode': false}}
#        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
#        When method Put
#        Then status 200
#        And match $.txRef == '#string'
#        And match $.error.msg == "token doesn't belong to the provided username"
#        And match $.error.code == "6003"
#        And match response == errorresponse
##
##            @ignore
#    Scenario: Update Profile invalid profile guid
#        * def GetProfilesRes = call read('common.feature@Add_profile')
#        * def GetProfiles = call read('common.feature@GetProfiles')
#        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/5454545454'
#        And request {'profileName': 'profile-2','profileSettings': {'parentalControl': 'PG18','defaultAudioLang': 'ar','passwordProtected': true,'defaultSubTitleLang': 'ar','autoPlayNextEpisode': false}}
#        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
#        When method Put
#        Then status 200
#        And match $.txRef == '#string'
#        And match $.error.msg == "invalid profile guid"
#        And match $.error.code == "9026"
#        And match response == errorresponse
#
##                @ignore
#    Scenario: Update Profile Invalid Request body
#        * def GetProfilesRes = call read('common.feature@Add_profile')
#        * def GetProfiles = call read('common.feature@GetProfiles')
#        Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + GetProfiles.ProfileName.profileGuid
#        And request {}
#        And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
#        When method Put
#        Then status 200
#        And match $.txRef == '#string'
#        And match $.error.msg == "Invalid request body"
#        And match $.error.code == "1001"
#        And match response == errorresponse