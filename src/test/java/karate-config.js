function fn() {
  var config = {
    serverUrl : 'https://reqres.in/',
    randomName: makeid(),
    randomEmail: makeEmail()
  };
  function makeid() {
    var length=5;
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
  }
  function makeEmail() {
    var strValues="abcdefg12345";
    var strEmail = "";
    var strTmp;
    for (var i=0;i<10;i++) {
      strTmp = strValues.charAt(Math.round(strValues.length*Math.random()));
      strEmail = strEmail + strTmp;
    }
    strTmp = "";
    strEmail = strEmail + "@";
    strEmail = strEmail + "gmail";
    strEmail = strEmail + ".com"
    return strEmail;
  }
  return config;
}