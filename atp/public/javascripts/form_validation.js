function cleanTags(el){
	str = $(el).value;
	illegalChars= /[\(\)\<\>\,\;\:\\\"\[\]]/
	str = str.replace(/,/,'\n')
	return str.split(' ').each(function(r){ if (r.length>1) return r.stripPunctuation().stripTags(); });
}
function checkEmail (strng) {
	var error="";
	if (strng == "") {
	   error = "You didn't enter an email address.\n";
	}
	
		var emailFilter=/^.+@.+\..{2,3}$/;
		if (!(emailFilter.test(strng))) { 
		   error = "Please enter a valid email address.\n";
		}
		else {
	//test email for illegal characters
		   var illegalChars= /[\(\)\<\>\,\;\:\\\"\[\]]/
			 if (strng.match(illegalChars)) {
			  error = "The email address contains illegal characters.\n";
		   }
		}
	return error;
}
function checkUsername (strng) {	
	var error = "";
	if (strng == "") {
	   error = "You did not enter a username.";
	}
	
	if ((strng.length < 3) || (strng.length > 75)) {
	   error = "The username is the wrong length. Must be 3-12 characters.";
	}
	return error;
} 
function checkPassword(strng) {
	var error = "";
	if (strng == "") {
	   error = "You didn't enter a password.\n";
	}
		var illegalChars = /[\W_]/; // allow only letters and numbers
		if ((strng.length < 3) || (strng.length > 12)) {
		   error = "The password length is between 3 and 12 characters.\n";
		}
		else if (illegalChars.test(strng)) {
		  error = "The password contains illegal characters.\n";
		} 
		else if (!((strng.search(/(a-z)+/)) && (strng.search(/(A-Z)+/)) && (strng.search(/(0-9)+/)))) {
		   error = "The password must contain at least one uppercase letter, one lowercase letter, and one numeral.\n";
		}  
	return error;    
}
function raise_flag(why){
    if (why != "") {
       alert(why);
       return false;
    }
	return true;
}
function raise_flag_with_msg(why){
    if (why != "") {
       new Message(why);
       return false;
    }
	return true;
}

function is_email_valid(e) {
	var ok = "1234567890qwertyuiop[]asdfghjklzxcvbnm.@-_QWERTYUIOPASDFGHJKLZXCVBNM";
	for(var i=0; i<e.length; i++){
		if (ok.indexOf(e.charAt(i))<0) {
			return false;
		}
	}
	if (document.images) {
		var re = /(@.*@)|(\.\.)|(^\.)|(^@)|(@$)|(\.$)|(@\.)/;
		var re_two = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,8}|[0-9]{1,3})(\]?)$/;
		if (!e.match(re) && e.match(re_two)) {
			return -1;
		}
	}
}