document.write('<script type="text/javascript" src="/javascripts/md5.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/form_validation.js"></script>');

function rememberMe() {
  if (ID('user_username') != undefined)
    D.cookie("login", dojo.toJson({username: F("user_username") , password: F("user_password"), md5: F("md5")  }), { expires: App.cookie.expires_in_days });
}

function process_cookie() {
	if (ID('cookie_remember_me').checked == true) { rememberMe(); }
	else {
    delete_login_cookie();
  }
}

function process_and_hash(ev){
	ID('user_username').value = F('user_username').trim();
	ID('user_password').value = F('user_password').trim();
	if (!raise_flag_with_msg(checkUsername(F('user_username')))){
		ID('user_username').focus();
		ev.preventDefault();
		return false;
	}
	if (!raise_flag_with_msg(checkPassword(F('user_password')))){
		ID('user_password').focus();
		ev.preventDefault();
		return false;
	}
	new Message("Logging in....", "notice");
	process_cookie();
  password_scramble();
}

function password_scramble() {
	if (MD5("fcgmedia") == "f1075e8a29f8a0cdfb524c17a8ff0452") {
		var passwd = F('user_password');
		if (passwd){
			ID('user_password').value= MD5(passwd);
			ID('md5').value=1;
		} else {
			ID('md5').value=0;
		}
  }
}

function delete_login_cookie(){
  D.cookie("login", null, {expires: -1});
  return true;
}

D.addOnLoad(function() { 
  C(ID("login_form"), "submit", "process_and_hash");
  
  try{
    ID('cookie_remember_me').checked = true;
  } catch(e){}
  
	if (D.isString(D.cookie("login"))) {
	  try{
  	  FCG.c = dojo.fromJson(D.cookie("login"));
  	  ID('user_username').value = FCG.c.username;
  	  ID('user_password').value = FCG.c.password;
  	  ID('md5').value = FCG.c.md5; 
	  } catch(e){
  	  FCG.c = D.cookie("login").split("|");
  	  ID('user_username').value = FCG.c[0];
  	  ID('user_password').value = FCG.c[1];
  	  ID('md5').value = FCG.c[2];
  	  delete_login_cookie();
	  }
	}
	
	if (F('user_username').length > 6){
		ID('user_password').focus();
	} else {
		ID('user_username').focus();
	}
});