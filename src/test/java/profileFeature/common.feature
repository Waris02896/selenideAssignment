@ignore
Feature: Auth Token

  Background:
    * url serverUrl
    * def Token = 'GDMSTGExy0sVDlZMzNDdUyZ'
    * def User = 'multiprofile@mailinator.com'
    * def encPass = 'MTU4Nzg5Mzg5NjAwMDoxMjM0NTY='
    * def epoch = '1587893896000'
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

  @user_token @ignore
  Scenario: Successful User Token Get
    Given path 'bolt-v2/v2/'+ Token +'/login/credentials'
#    * def result = call read('common.feature@user_token')
    And request {username: 'multiprofile@mailinator.com', password: '123456', userAgent: 'android'}
    When method Post
    Then status 200
#    And print response
#    And print response.data.authToken

  @GetProfiles @ignore
  Scenario: Successful Response Get
    Given path 'profiles/v3/' + Token +'/users/'+ User +'/profiles'
    * def result = call read('common.feature@user_token')
    * header Authorization = result.response.data.authToken
    When method GET
    Then status 200
    * def PN = get[0] response.data.profiles[?(@.profileName=="profile-2")]


  @GetProfilesIndex @ignore
  Scenario: Successful Response Get Index
#    * def res = call read('common.feature@AddMultipleProfiles')
#    * def res = call read('common.feature@AddMultipleProfiles')
    Given path 'profiles/v3/' + Token +'/users/'+ User +'/profiles'
    * def result = call read('common.feature@user_token')
    * header Authorization = result.response.data.authToken
    When method GET
    Then status 200
    * def item = get[1] response.data.profiles
#    And print item
#    * def item2 = get[2] response.data.profiles

    @DeleteProfile @ignore
  Scenario: Delete Profile Successful
      * def result = call read('common.feature@user_token')
    * def GetProfiles = call read('common.feature@Add_profile')
    * def GetProfiles12 = call read('common.feature@GetProfiles')
    Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + GetProfiles12.ProfileName.profileGuid
    And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
    When method Delete
    Then status 200
#    And print response


  @Deleteforpost @ignore
  Scenario: Delete Profile Successful
    * def result = call read('common.feature@user_token')
    * def GetProDel = call read('common.feature@GetProfiles')
    Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + GetProDel.PN.profileGuid
    And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
    When method Delete
    Then status 200

      @Add_profile @ignore
  Scenario: Add User Profile once
        * def GetProffordeletetestcase = call read('common.feature@Deleteforpost')
    Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
        * def result = call read('common.feature@user_token')
    * headers {Authorization : '#(result.response.data.authToken)'}
    And request {'profileName': "profile-2",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
    When method Post
    Then status 200
        * def resp = response
#    And print response

  @Add_profileforupdate @ignore
  Scenario: Add User Profile
    Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
    * def res = call read('common.feature@DeleteSingleFirstIndex')
    * def result = call read('common.feature@user_token')
    * headers {Authorization : '#(result.response.data.authToken)'}
    And request {'profileName': "profile-2",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
    When method Post
    Then status 200

  @DeleteSingleFirstIndex @ignore
  Scenario: Delete Profile Successful Single
    * def result = call read('common.feature@user_token')
    * def GetProfiles = call read('common.feature@GetProfilesIndex')
#    And print GetProfiles
    Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + GetProfiles.item.profileGuid
    And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
    When method Delete
#    And print GetProfiles
    Then status 200
#    And print response

  @DeleteSingleSecondIndex @ignore
  Scenario: Delete Profile Successful Single
    * def result = call read('common.feature@user_token')
    * def GetProfiles = call read('common.feature@GetProfilesIndex')
#    And print GetProfiles
    Given path 'profiles/v3/' + Token +'/users/'+ User +'/profile/' + GetProfiles.item2.profileGuid
    And headers {encPassword: MTU4Nzg5Mzg5NjAwMDoxMjM0NTY, epochMs: 1587893896000, Authorization : '#(result.response.data.authToken)'}
    When method Delete
#    And print GetProfiles
    Then status 200
#    And print response

  @ignore @AddMultipleProfiles
  Scenario: Add multiple Profile
#    * def result = call read('common.feature@user_token')
    Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
    * headers {Authorization : '#(result.response.data.authToken)'}
    And request {'profileName': " #(ProfileName)",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
    When method Post
    Then status 200
#    And print response

  @ignore @RandomProfileAdd
  Scenario: Add multiple Profile
#    * def result = call read('common.feature@user_token')
    Given path 'profiles/v3/'+ Token +'/users/'+ User +'/profile'
    * headers {Authorization : '#(result.response.data.authToken)'}
    And request {'profileName': " #(ProfileName)",'profileSettings': {'parentalControl': 'R18','defaultAudioLang': 'en','passwordProtected': false,'defaultSubTitleLang': 'en','autoPlayNextEpisode': true}}
    When method Post
    Then status 200