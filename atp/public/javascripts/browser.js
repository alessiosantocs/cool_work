function gff(str, pfx) {
	var i = str.indexOf(pfx);
	if (i != -1) {
		var v = parseFloat(str.substring(i + pfx.length));
		if (!isNaN(v)) {
			return v;
		}
	}
	return null;
}

function is_ajax_ready(b){
	if (b.ie && !b.op && !b.mac) {
		if (b.agt.indexOf("palmsource") != -1 ||
			b.agt.indexOf("regking") != -1 ||
			b.agt.indexOf("windows ce") != -1 ||
			b.agt.indexOf("j2me") != -1 ||
			b.agt.indexOf("avantgo") != -1 ||
			b.agt.indexOf(" stb") != -1)  {
			return false;
		}
		var v = gff(b.agt, "msie ");
		if (v != null) {
			return (v >= 5.5);
		}
	}
	if (b.gk && !b.sf) {
		var v = gff(b.agt, "rv:");
		if (v != null) {
			return (v >= 1.4);
		} else {
			v = gff(b.agt, "galeon/");
			if (v != null) {
				return (v >= 1.3);
			}
		}
	}
	if (b.sf) {
		var v = gff(b.agt, "applewebkit/");
		if (v != null) {
			return (v >= 124);
		}
	}
	if (b.op) {
		// Could have "Opera 8.0" or "Opera/8.0".
		var v = gff(b.agt, "opera ");
		if (v == null) {
			v = gff(b.agt, "opera/");
		}
		if (v != null) {
			return (v >= 8.0);
		}
	}
	return false;
}

function Browser(){
	d=document;
	this.agt=navigator.userAgent.toLowerCase();
	this.major = parseInt(navigator.appVersion);
	this.dom=(d.getElementById)?1:0; // true for ie6, ns6
	this.ns=(d.layers);
	this.ns4up=(this.ns && this.major >=4);
	this.ns6=(this.dom&&navigator.appName=="Netscape");
	this.op= /opera/.test(this.agt);
	this.ie= /msie/.test(this.agt);
	this.ie4=(this.ie &&!this.dom)?1:0;
	this.ie4up=(this.ie && this.major >= 4);
	this.ie5 = /msie 5/.test(this.agt) && this.ie && !this.op;
	this.ie6 = /msie 6/.test(this.agt) && this.ie && !this.op;
	this.win=(/win/.test(this.agt) || /16 bit/.test(this.agt));
	this.mac=/mac/.test(this.agt);
	this.sf = /safari/.test(this.agt);
	this.gk = /gecko/.test(this.agt);
	this.firefox = /firefox/.test(this.agt);
	this.moz = (window.navigator != null) ? (this.agt.indexOf("gecko") != -1) : false;
	this.nn4 = (this.ns && !this.moz);
	this.dom1 = false;	// fully supports DOM1
	this.dom2 = false;	// fully supports (important bits of) DOM2
	wdi = window.document.implementation;
	if (wdi != null) {
		this.dom1 = wdi.hasFeature("HTML","1.0");
		this.dom2 = wdi.hasFeature("HTML","2.0") && wdi.hasFeature("Events","2.0") && wdi.hasFeature("Core","2.0") && wdi.hasFeature("CSS2","2.0");
	}
	this.old = (!this.ie4 && !this.ie5 && !this.ie6 && !this.dom1 && !this.nn4 && !this.moz);
	this.ajax=is_ajax_ready(this); // Ajax support
}

function is_browser_supported(){ 
	if (/checkbrowser/.test(top.location.pathname)){ return true; }
	var testcookie = "jscookietest=valid"; 
	document.cookie = testcookie; 
	if (document.cookie.indexOf(testcookie) == -1) { top.location = "page/nocookies.html"; return false; }
	document.cookie = testcookie + ";expires=Thu, 01 Jan 1970 00:00:00 GMT";
	var agt = navigator.userAgent.toLowerCase(); 
	if (!_b.ie && document.all && agt.indexOf("opera") == -1 && agt.indexOf("mac") == -1) { 
		eval("var c=(agt.indexOf(\"msie 5\")!=-1)?\"Microsoft.XMLHTTP\":\"Msxml2.XMLHTTP\";try{new ActiveXObject(c);}catch(e){top.location=\"html/noactivex.html\";}");
	}
	return true;
}
//var _b = new Browser();