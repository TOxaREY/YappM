var apn = require('apn');
var XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;
var allflags = [];
var biflag = [];
var hexflag = [];
var alljsoncount = 0;
var bicount = 0;
var hexcount = 0;
var checkcount = 0;
var countrequest1 = 0;
var countrequest2 = 0;
var sch = 0;
var app = '';
var letters = {A:"\u{1F1E6}",B:"\u{1F1E7}",C:"\u{1F1E8}",D:"\u{1F1E9}",E:"\u{1F1EA}",F:"\u{1F1EB}",G:"\u{1F1EC}",H:"\u{1F1ED}",I:"\u{1F1EE}",J:"\u{1F1EF}",K:"\u{1F1F0}",L:"\u{1F1F1}",M:"\u{1F1F2}",N:"\u{1F1F3}",O:"\u{1F1F4}",P:"\u{1F1F5}",Q:"\u{1F1F6}",R:"\u{1F1F7}",S:"\u{1F1F8}",T:"\u{1F1F9}",U:"\u{1F1FA}",V:"\u{1F1FB}",W:"\u{1F1FC}",X:"\u{1F1FD}",Y:"\u{1F1FE}",Z:"\u{1F1FF}"};

// Repeats send
var timerReq = setInterval(function() {
// Add current date	
var date = new Date();
console.log('start ' + date);
var year = date.getFullYear().toString();
var dayinit = date.getDate().toString();
if (dayinit < 10) {
  var day = "0" + dayinit.toString()
} else {
      day = dayinit.toString()
};
var monthint = date.getMonth() + 1;
if (monthint < 10) {
	var month = "0" + monthint.toString()
} else {
	    month = monthint.toString()
};
var today = year + "-" + month + "-" + day;
var https1 = "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=1087083&date_since=" + today + "%2000%3A00%3A00&date_until=" + today + "%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code&oauth_token=AQAAAAAhPETSAAT2D89FSOxLukvSkqayXbCBReA";
var https2 = "https://api.appmetrica.yandex.ru/logs/v1/export/installations.json?application_id=1537733&date_since=" + today + "%2000%3A00%3A00&date_until=" + today + "%2023%3A59%3A59&date_dimension=default&use_utf8_bom=true&fields=country_iso_code&oauth_token=AQAAAAAhPETSAAT2D89FSOxLukvSkqayXbCBReA";
var xhr1 = new XMLHttpRequest();
var xhr2 = new XMLHttpRequest();
// Request app1
// First and second request    
// Config first and second request get
xhr1.open('GET', https1, false);
xhr2.open('GET', https2, false);
// Add header
xhr1.setRequestHeader('Cache-Control', 'max-age=120');
xhr2.setRequestHeader('Cache-Control', 'max-age=120');
// Add timeout async request
xhr1.timeout = 60000;
xhr2.timeout = 60000;
// Send request
xhr1.send();
xhr2.send();
// App1
if (xhr1.status == 202) {
  console.log('start 202');
secondrequest(xhr1, https1, countrequest1, 'bi');
} else {
    if (xhr1.status == 200) {
request200(xhr1, countrequest1, 'bi');
} else {
  console.log(xhr1.responseText)
}};
//App2
if (xhr2.status == 202) {
  console.log('start 202');
secondrequest(xhr2, https2, countrequest2, 'hex');
} else {
    if (xhr2.status == 200) {
request200(xhr2, countrequest2, 'hex');
} else {
  console.log(xhr2.responseText)
}};
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
  	console.log('202 ' + countrequest);
countrequest += 1;
secondrequest(xhr, https, countrequest, app);
} else {
    if (xhr.status == 200) {
request200(xhr, countrequest, app);
} else {
  console.log(xhr.responseText);
}}} else {
  countrequest = 0;
}}, 10000);
};
}, 540000);
// Processing data and send
var timerSend = setInterval(function() {
	var date2 = new Date();
	allflags = biflag + hexflag;
	alljsoncount = bicount + hexcount;
  console.log('check ' + date2);
  console.log(alljsoncount);
  console.log(allflags);
  if (alljsoncount != 0) {
    console.log('check ' + checkcount);
    if (checkcount < alljsoncount) {
      notif(allflags,alljsoncount,'int.aiff');
      sch = 0;
     }
  } else { 
    if (sch == 0) {
    notif('сброс',0,'silence.aiff');
    sch += 1;
    }};
}, 1200000);
// Function request if 200
function request200(xhr, countrequest, app) {
	console.log('200');
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
             flags += ("\u{1F3F3}" + "\u{FE0F}" + "\u{200D}" + "\u{1F308}");
          } else {
        flags += (letters[jsoniso[i].charAt(0)] + letters[jsoniso[i].charAt(1)]);
        }};
               if (app == 'bi') {
                  biflag += flags;
                  bicount += jsoncount;
                  console.log('bi ' + biflag);
                  console.log('bi ' + bicount);
                } else {
                    hexflag += flags;
                    hexcount += jsoncount;
                    console.log('hex ' + hexflag);
                    console.log('hex ' + hexcount);
                }
      }
    };

// Function notification
function notif(allflags,alljsoncount,sound) {
// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider({  
     token: {
        key: 'apns.p8', // Path to the key p8 file
        keyId: 'JYZ26C6LUW', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
        teamId: 'EB6R5QS764', // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
    },
    production: false // Set to true if sending a notification to a production iOS app
});
// Enter the device token from the Xcode console
var deviceToken = '7160ddb6ad23d38679389cae7f5e9f2a4c7610ed4911b2916e523887f81ceb95';
// Prepare a new notification
var notification = new apn.Notification();
// Specify your iOS app's Bundle ID (accessible within the project editor)
notification.topic = 'deltaTOxaREY.YappM';
// Set expiration to 1 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 3600;
// Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
notification.payload = {id: 123};
// Display the following message (the actual notification text, supports emoji)
notification.alert = allflags;
// Set app badge indicator
notification.badge = alljsoncount;
// Play ping.aiff sound when the notification is received
notification.sound = sound;
// Actually send the notification
apnProvider.send(notification, deviceToken).then(function(result) {  
    // Check the result for any failed devices
    // console.log(result);
    console.log('send');
apnProvider.shutdown();
checkcount = alljsoncount;  
})
};

