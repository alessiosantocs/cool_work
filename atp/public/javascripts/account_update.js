document.write('<script type="text/javascript" src="/javascripts/form_validation.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/countries.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/timezones.js"></script>');

function validate_via_ajax(el){
	new Ajax.CustomRequest('/account/validate?name='+el.id+"&value="+el.value, {
		onSuccess: function(r){eval(r.responseText)},
		on400: function(r){eval(r.responseText)},
		onLoading: function(){}
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