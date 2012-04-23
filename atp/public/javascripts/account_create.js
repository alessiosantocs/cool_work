document.write('<script type="text/javascript" src="/javascripts/form_validation.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/countries.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/timezones.js"></script>');

function validate(){
	//country
	if ($F('user_country').length != 2){
		new Message("Select a Country");
		$('user_country').focus();
		return false;
	}
	//username
	if (!raise_flag_with_msg(checkUsername($F('user_username')))){
		$('user_username').focus();
		return false;
	}
	// company name
	if (($F('role_promoter') == 1 || $F('role_promoter') == 1) &&
	    $F('user_company_name').length<1){
		new Message("All promoters/photographers must have a company name.");
		$('user_company_name').focus();
		return false;
	}
	//email address	
	if (!raise_flag_with_msg(checkEmail($F('user_email')))){
		$('user_email').focus();
		return false;
	}
	$('user_email').value = $F('user_email').toLowerCase();
	$('user_email_confirmation').value = $F('user_email_confirmation').toLowerCase();
	if ($F('user_email_confirmation') != $F('user_email')){
		new Message( "The emails don't match.");
		$('user_email_confirmation').focus();
		return false;
	}
	//passwords
	if (!raise_flag_with_msg(checkPassword($F('user_password')))){
		$('user_password').focus();
		return false;
	}
	if ($F('user_password_confirmation') != $F('user_password')){
		new Message( "The passwords don't match.");
		$('user_password_confirmation').focus();
		return false;
	}
	//mobile carrier
	if ($F('user_mobile').length > 0 && $F('user_mobile_carrier').length == 0 ){
		new Message("Select a mobile carrier");
		$('user_mobile_carrier').focus();
		return false;
	}

	//city and state for non-us countries
	if ($F('user_country')!='us'){
		if ($F('user_city').length<1){
			new Message("Enter the city");
			$('user_city').focus();
			return false;
		}
		if ($F('user_state').length<1){
			new Message("Enter the state or province");
			$('user_state').focus();
			return false;
		}
	}
	//country
	if ($F('user_sex').length < 1){
		new Message("Choose your sex.");
		$('user_sex').focus();
		return false;
	}
	//postal code
	if ($F('user_country')=='us' && $F('user_postal_code').length!=5){
		new Message( "Enter your postal code");
		$('user_postal_code').focus();
		return false;
	}
}
/*"(null)@http://nyc.fcgmedia.local/javascripts/prototype.js?1170364656:1992
validate()@http://nyc.fcgmedia.local/javascripts/account_create.js?1170368351:13
onsubmit([object Event])@http://nyc.fcgmedia.local/account/create:1\n@:0
"
*/
function validate_via_ajax(el){
	new Ajax.CustomRequest('/account/validate?name='+el.id+"&value="+el.value, {
		onSuccess: function(r){eval(r.responseText)},
		on400: function(r){eval(r.responseText)}
	});
}

function whatsYourRole(){
	if ($F("role_promoter") == 1){
		Element.show("company_name");
		new Effect.Highlight("company_name");
	} else {
		Element.hide("company_name");
	}
}

function zip_action(){
	if ($F('user_country') == "us"){
		Element.show("div_postal_code_form");
		Element.hide("city_state");
		$('user_city').value='';
		$('user_state').value='';
	} else if ($F('user_country').length == 2){
		Element.show("city_state");
		Element.hide("div_postal_code_form");
	} else {
		$('user_postal_code').value == "";
		Element.show("city_state");
		Element.hide("div_postal_code_form");
	}
	return true;
}

function get_zip_data(){
	opt = {
    postBody: 'postal_code='+$F('user_postal_code')+'&country='+$F('user_country'),
    onLoading:'',
		onSuccess:function(r){
			eval(r.responseText); 
			setTimeout(function(){
				if(zFlag==true){
					new Message('').clear();
					$('user_city').value = city;
					$('user_state').value = state;
				} else {
					new Message( "The postal code ("+$F('user_postal_code')+") doesn't exist in our system.");
				}
			}, 250);
		}
	}
	new Ajax.CustomRequest('/postal_code/find', opt);
}

Event.addBehavior({
  "form#login": function(event) {
    Element.remove(this);
  },
  "body": function(event) {
		whatsYourRole();
		if ($F('user_postal_code').length==5){ get_zip_data(); }
		zip_action();
		$('role_promoter').focus();
  },
  "#username_submit:click": function(event) {
		if (raise_flag_with_msg(checkUsername($F('user_username')))){ 
			if (!validate_via_ajax($('user_username'))){ 
				new Message( 'The name is currently available.' ,'good'); 
			}
		}
  },
  "#user_country:change": function(event) {
    zip_action()
  },
  "#user_role:change": function(event) {
    whatsYourRole();
  },
  "#user_postal_code:change": function(event) {
    get_zip_data()
  },
  "#role_promoter:change": function(event) {
    whatsYourRole();
  }
});