var apn = require('apn');
var XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;
var allflags = '';
var biflag = '';
var hexflag = '';
var alljsoncount = 0;
var bicount = 0;
var hexcount = 0;
var bicountYes = 0;
var hexcountYes = 0;
var alljsoncountYes = 0;
var checkcount = 0;
var checkflags = '';
var countrequest1 = 0;
var countrequest2 = 0;
var countrequestYes = 0;
var app = '';
var letters = {A:"\u{1F1E6}",B:"\u{1F1E7}",C:"\u{1F1E8}",D:"\u{1F1E9}",E:"\u{1F1EA}",F:"\u{1F1EB}",G:"\u{1F1EC}",H:"\u{1F1ED}",I:"\u{1F1EE}",J:"\u{1F1EF}",K:"\u{1F1F0}",L:"\u{1F1F1}",M:"\u{1F1F2}",N:"\u{1F1F3}",O:"\u{1F1F4}",P:"\u{1F1F5}",Q:"\u{1F1F6}",R:"\u{1F1F7}",S:"\u{1F1F8}",T:"\u{1F1F9}",U:"\u{1F1FA}",V:"\u{1F1FB}",W:"\u{1F1FC}",X:"\u{1F1FD}",Y:"\u{1F1FE}",Z:"\u{1F1FF}"};
var deviceTokenArray = [];
var totalCount = '';
var totalCountTod = '';
var finishFlag = "\u{1F3C1}";
var conf = "\u{1F389}";
var champ = "\u{1F37E}";
var check = '';
var maxcount = 0;
var checkmaxcount = 0;
var ajcy = 0;

//Start req & check
var today = new Date();
console.log('start requests ' + today);
request(today, 'today');
checkYes();
// Repeats checking yesterday
var yesterdayCheck = setInterval(function() {
  checkYes();
},
86400000);
// Repeats send
var timerReq = setInterval(function() {
// Add current date	
var today = new Date();
console.log('start requests ' + today);
request(today, 'today');
}, 1080000);
// Processing data and send
var timerSend = setInterval(function() {
	var date2 = new Date();
	allflags = biflag + hexflag;
	alljsoncount = bicount + hexcount;
  var checkflagsarray = checkflags.split(' ');
  checkflagsarray.sort();
  var allflagsarray = allflags.split(' ');
  allflagsarray.sort();

  console.log('start checking responses ' + date2);
  console.log('all count ' + alljsoncount);
  console.log('all flags ' + allflags);
  console.log('check ' + alljsoncount + ' V ' + checkcount);
  console.log('total ' + totalCount + ' + ' + alljsoncount);
  
  if (checkcount < alljsoncount) {
    for (var i = 0; i <= deviceTokenArray.length - 1; i++) {
     notif(allflags,alljsoncount,'int.aiff',deviceTokenArray[i],'send')
   }};

   if (checkcount == alljsoncount && checkflagsarray.join('') != allflagsarray.join('')) {
    for (var i = 0; i <= deviceTokenArray.length - 1; i++) {
     notif(allflags,alljsoncount,'int.aiff',deviceTokenArray[i],'send')
   }}; 
 }, 1200000);
// Function checking yesterday
function checkYes() {
  var now = new Date();
  var timeCheck = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 5, 0, 0) - now;
  console.log('start now timer ' + now);
  if (timeCheck < 0) {
   timeCheck += 86400000;
 }
 setTimeout(function(){
   var yesterday = new Date();
   yesterday.setDate(yesterday.getDate() - 1);
   request(yesterday, 'yesterday')}, timeCheck);
 setTimeout(function(){
  checkmaxcount = +bicountYes + +hexcountYes;
  ajcy = +bicountYes + +hexcountYes + +totalCountTod;
  alljsoncountYes = checkmaxcount + "/" + ajcy;
  console.log('yescount&today ' + alljsoncountYes);
  for (var i = 0; i <= deviceTokenArray.length - 1; i++) {
    notif(finishFlag,alljsoncountYes,'silence.aiff',deviceTokenArray[i],'yes')};
    var data = "total=" + ajcy;
    var xhrTall = new XMLHttpRequest();
    xhrTall.withCredentials = true;
    xhrTall.open("PUT", "http://133.33.133.33:8000/token/5b8294fc39e883f39vvvvvvv");
    xhrTall.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhrTall.setRequestHeader("Cache-Control", "no-cache");
    xhrTall.send(data);
    console.log('send mongo ' + data);

    if (checkmaxcount > maxcount) {
      var data2 = "max=" + checkmaxcount;
      var xhrMaxx = new XMLHttpRequest();
      xhrMaxx.withCredentials = true;
      xhrMaxx.open("PUT", "http://133.33.133.33:8000/token/5ba48c368389d9d1vvvvvvv");
      xhrMaxx.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      xhrMaxx.setRequestHeader("Cache-Control", "no-cache");
      xhrMaxx.send(data2);
      console.log('send mongo ' + data2);
    };
  }, timeCheck += 300000);
};

// Function convert Date to string
function stringDate(date) {
  year = date.getFullYear().toString();
  dayinit = date.getDate().toString();
  if (dayinit < 10) {
    var day = "0" + dayinit.toString()
  } else {
    day = dayinit.toString()
  };
  monthint = date.getMonth() + 1;
  if (monthint < 10) {
    month = "0" + monthint.toString()
  } else {
    month = monthint.toString()
  };
  return year + "-" + month + "-" + day};
// Function requests
function request(date, day){
  if (day == 'today'){
    https1 = "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=1087083&date_since=" + stringDate(date) + "%2000%3A00%3A00&date_until=" + stringDate(date) + "%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code";
    https2 = "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=1537733&date_since=" + stringDate(date) + "%2000%3A00%3A00&date_until=" + stringDate(date) + "%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code";
    httpTd = "http://133.33.133.33:8000/token/5b7784e05030c080cvvvvvvv";
    httpTl = "http://133.33.133.33:8000/token/5b8294fc39e954f40vvvvvvv";
  };
  if (day == 'yesterday'){
    https11 = "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=1087083&date_since=" + stringDate(date) + "%2000%3A00%3A00&date_until=" + stringDate(date) + "%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code";
    https22 = "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=1537733&date_since=" + stringDate(date) + "%2000%3A00%3A00&date_until=" + stringDate(date) + "%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code";
    httpTll = "http://133.33.133.33:8000/token/5b8294fc39e954f40vvvvvvv";
    httpMax = "http://133.33.133.33:8000/token/5ba48c368389d9d19vvvvvvv";
  };
  if (day == 'today'){  
    xhr1 = new XMLHttpRequest();
    xhr2 = new XMLHttpRequest();
    xhrTd = new XMLHttpRequest();
    xhrTl = new XMLHttpRequest();
  };
  if (day == 'yesterday'){
    xhr11 = new XMLHttpRequest();
    xhr22 = new XMLHttpRequest();
    xhrTll = new XMLHttpRequest();
    xhrMax = new XMLHttpRequest();
  };
// Request app1
// First and second and token request   
// Config first and second and token and total request get
if (day == 'today'){
  xhr1.open('GET', https1, false);
  xhr2.open('GET', https2, false);
  xhrTd.open('GET', httpTd, false);
  xhrTl.open('GET', httpTl, false);
};
if (day == 'yesterday'){
  xhr11.open('GET', https11, false);
  xhr22.open('GET', https22, false);
  xhrTll.open('GET', httpTll, false);
  xhrMax.open('GET', httpMax, false);
};  
// Add header
if (day == 'today'){
  xhr1.setRequestHeader('Cache-Control', 'max-age=60');
  xhr1.setRequestHeader('Authorization', 'OAuth AQAAAAAhPETSAAT2D89FSOxLukvSkqayvvvvvvv');
  xhr2.setRequestHeader('Cache-Control', 'max-age=60');
  xhr2.setRequestHeader('Authorization', 'OAuth AQAAAAAhPETSAAT2D89FSOxLukvSkqayvvvvvvv');
};
if (day == 'yesterday'){
  xhr11.setRequestHeader('Cache-Control', 'max-age=60');
  xhr11.setRequestHeader('Authorization', 'OAuth AQAAAAAhPETSAAT2D89FSOxLukvSkqayvvvvvvv');
  xhr22.setRequestHeader('Cache-Control', 'max-age=60');
  xhr22.setRequestHeader('Authorization', 'OAuth AQAAAAAhPETSAAT2D89FSOxLukvSkqayvvvvvvv');
};	
// Add timeout async request
if (day == 'today'){
  xhr1.timeout = 60000;
  xhr2.timeout = 60000;
  xhrTd.timeout = 60000;
  xhrTl.timeout = 60000;
};
if (day == 'yesterday'){
  xhr11.timeout = 60000;
  xhr22.timeout = 60000;
  xhrTll.timeout = 60000;
  xhrMax.timeout = 60000;
};
// Send request
if (day == 'today'){
  xhr1.send();
  xhr2.send();
  xhrTd.send();
  xhrTl.send();
};
if (day == 'yesterday'){
  xhr11.send();
  xhr22.send();
  xhrTll.send();
  xhrMax.send();
};
if (day == 'today'){
// Token json
if (xhrTd.status == 200) {
  jsonPars = JSON.parse(xhrTd.responseText);
  deviceTokenArray = jsonPars.tokenDevice;
};
// Total json
if (xhrTl.status == 200) {
  jsonTotal = JSON.parse(xhrTl.responseText);
  totalCount = jsonTotal.total;
};
};
if (day == 'yesterday'){
// Total json
if (xhrTll.status == 200) {
  jsonTotalTod = JSON.parse(xhrTll.responseText);
  totalCountTod = jsonTotalTod.total;
};
// Max count
if (xhrMax.status == 200) {
  jsonMax = JSON.parse(xhrMax.responseText);
  maxcount = jsonMax.max;
};
};

if (day == 'today'){
// App1
if (xhr1.status == 202) {
  console.log('start 202 bi');
  secondrequest(xhr1, https1, countrequest1, 'bi');
} else {
  if (xhr1.status == 200) {
    request200(xhr1, countrequest1, 'bi');
  } else {
    console.log('bi start req error ' + xhr1.responseText)
  }};
//App2
if (xhr2.status == 202) {
  console.log('start 202 hex');
  secondrequest(xhr2, https2, countrequest2, 'hex');
} else {
  if (xhr2.status == 200) {
    request200(xhr2, countrequest2, 'hex');
  } else {
    console.log('hex start req error ' + xhr2.responseText)
  }}};


  if (day == 'yesterday'){
    var nowYes = new Date();
// App1
if (xhr11.status == 202) {
  console.log('startYes 202 bi' + nowYes);
  secondrequestyes(xhr11, https11, countrequestYes, 'bi');
} else {
  if (xhr11.status == 200) {
    request200yes(xhr11, countrequestYes, 'bi');
  } else {
    console.log('bi startYes req error ' + xhr11.responseText)
  }};
//App2
if (xhr22.status == 202) {
  console.log('startYes 202 hex' + nowYes);
  secondrequestyes(xhr22, https22, countrequestYes, 'hex');
} else {
  if (xhr22.status == 200) {
    request200yes(xhr22, countrequestYes, 'hex');
  } else {
    console.log('hex startYes req error ' + xhr22.responseText)
  }}};
};


// Function second request    
function secondrequest(xhr, https, countrequest, app) {
// Timeout start
setTimeout(function() {
// Config second request get
xhr.open('GET', https, false);
// Add timeout async request
xhr.timeout = 60000;
// Send request
xhr.send();
if (countrequest < 5) {
  if (xhr.status == 202) {
    console.log('202 '+ app + countrequest);
    countrequest += 1;
    secondrequest(xhr, https, countrequest, app);
  } else {
    if (xhr.status == 200) {
      request200(xhr, countrequest, app);
    } else {
      console.log(app + 'req error ' + xhr.responseText);
    }}} else {
      countrequest = 0;
    }}, 10000);
};
// Function request if 200
function request200(xhr, countrequest, app) {
  console.log('200 ' + app);
  if (app == 'bi') {
    biflag = [];
    bicount = 0;
  } else {
    hexflag = [];
    hexcount = 0;
  }
  countrequest = 0;
  var jsonresp = xhr.responseText;
  jsonresp = jsonresp.replace(/\r?\n|\r/g, "");
  jsonresp = jsonresp.substring(1);
  var json = JSON.parse(jsonresp);
  var jsoncount = json.data.length;
  if (jsoncount != 0) {
    var i;
    var jsoniso = [];
    for (i = 0; i < jsoncount; i++) {
      jsoniso.push(json.data[i].country_iso_code)
    };
    var i;
    var flags = [];
    for (i = 0; i < jsoncount; i++) {
      if (jsoniso[i] == '') {
       flags += ("\u{1F3F3}" + "\u{FE0F}" + "\u{200D}" + "\u{1F308}" + " ");
     } else {
      flags += (letters[jsoniso[i].charAt(0)] + letters[jsoniso[i].charAt(1)] + " ");
    }};
    if (app == 'bi') {
      biflag += flags;
      bicount += jsoncount;
      console.log('bi flags ' + biflag);
      console.log('bi count ' + bicount);
    } else {
      hexflag += flags;
      hexcount += jsoncount;
      console.log('hex flags ' + hexflag);
      console.log('hex count ' + hexcount);
    }
  }
};
// Function request if 200 yes
function request200yes(xhr, countrequest, app) {
  console.log('200Yes ' + app);
  if (app == 'bi') {
    bicountYes = 0;
  } else {
    hexcountYes = 0;
  }
  countrequest = 0;
  var jsonresp = xhr.responseText;
  jsonresp = jsonresp.replace(/\r?\n|\r/g, "");
  jsonresp = jsonresp.substring(1);
  var json = JSON.parse(jsonresp);
  var jsoncount = json.data.length;
  if (jsoncount != 0) {
    var i;
    var jsoniso = [];
    for (i = 0; i < jsoncount; i++) {
      jsoniso.push(json.data[i].country_iso_code)
    };
  };
  if (app == 'bi') {
    bicountYes += jsoncount;
    console.log('bi countYes ' + bicountYes);
  } else {
    hexcountYes += jsoncount;
    console.log('hex countYes ' + hexcountYes);
  }          
};
// Function second request yes    
function secondrequestyes(xhr, https, countrequest, app) {
// Timeout start
setTimeout(function() {
// Config second request get
xhr.open('GET', https, false);
// Add timeout async request
xhr.timeout = 60000;
// Send request
xhr.send();
if (countrequest < 20) {
  if (xhr.status == 202) {
    console.log('202Yes '+ app + countrequest);
    countrequest += 1;
    secondrequestyes(xhr, https, countrequest, app);
  } else {
    if (xhr.status == 200) {
      request200yes(xhr, countrequest, app);
    } else {
      console.log(app + 'reqYes error ' + xhr.responseText);
    }}} else {
      countrequest = 0;
    }}, 10000);
};
// Function notification
function notif(allflags,alljsoncount,sound,deviceToken,check) {
// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider({  
 token: {
        key: 'apns.p8', // Path to the key p8 file
        keyId: 'JYZvvvvvvv', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
        teamId: 'EB6vvvvvvv', // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
      },
    production: false // Set to true if sending a notification to a production iOS app
  });
// Prepare a new notification
var notification = new apn.Notification();
// Specify your iOS app's Bundle ID (accessible within the project editor)
notification.topic = 'deltaTOxaREY.YappM';
// Set expiration to 1 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 3600;
// Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
notification.payload = {id: 123};
// Display the following message (the actual notification text, supports emoji)
if (check == 'send') {
  notification.alert = allflags + " " + alljsoncount + "/" + (+alljsoncount + +totalCount);
}; 
if (check == 'yes') {
  if (checkmaxcount > maxcount) {
    notification.alert = finishFlag + " " + conf + " " + alljsoncount + " " + champ;
  } else {
    notification.alert = finishFlag + " " + alljsoncount;
  };

};
// Set app badge indicator
if (check == 'send') {
	notification.badge = alljsoncount;
}; 
if (check == 'yes') {
  notification.badge = 0;
};
// Play ping.aiff sound when the notification is received
notification.sound = sound;
// Actually send the notification
apnProvider.send(notification, deviceToken).then(function(result) {  
    // Check the result for any failed devices
    console.log(result);
    apnProvider.shutdown();
    if (check == 'yes') {
      checkcount = 0;
      checkflags = '';
      bicount = 0;
      hexcount = 0;
      biflag = '';
      hexflag = '';
      totalCount = alljsoncountYes;
    };
    if (check == 'send') {
      checkcount = alljsoncount;
      checkflags = allflags;
    };  
  })
};

