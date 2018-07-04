var oneflagsstring = [];
var twoflagsstring = [];
var letters = {A:"\u{1F1E6}",B:"\u{1F1E7}",C:"\u{1F1E8}",D:"\u{1F1E9}",E:"\u{1F1EA}",F:"\u{1F1EB}",G:"\u{1F1EC}",H:"\u{1F1ED}",I:"\u{1F1EE}",J:"\u{1F1EF}",K:"\u{1F1F0}",L:"\u{1F1F1}",M:"\u{1F1F2}",N:"\u{1F1F3}",O:"\u{1F1F4}",P:"\u{1F1F5}",Q:"\u{1F1F6}",R:"\u{1F1F7}",S:"\u{1F1F8}",T:"\u{1F1F9}",U:"\u{1F1FA}",V:"\u{1F1FB}",W:"\u{1F1FC}",X:"\u{1F1FD}",Y:"\u{1F1FE}",Z:"\u{1F1FF}"};

oneflagsstring += (letters['A'] + letters['U'] + ' ');
oneflagsstring += (letters['A'] + letters['U'] + ' ');
oneflagsstring += (letters['A'] + letters['U'] + ' ');
oneflagsstring += (letters['A'] + letters['U'] + ' ');

twoflagsstring += (letters['U'] + letters['A'] + ' ');
twoflagsstring += (letters['U'] + letters['A'] + ' ');
twoflagsstring += (letters['U'] + letters['A'] + ' ');
twoflagsstring += (letters['U'] + letters['A'] + ' ');



var onearray = oneflagsstring.split(' ');
onearray.sort();

var twoarray = twoflagsstring.split(' ')
twoarray.sort();

if (onearray.join('') == twoarray.join('')) {
	console.log('eql');
} else {
	console.log('not eql');
}

