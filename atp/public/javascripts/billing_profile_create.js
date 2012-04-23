document.write('<script type="text/javascript" src="/javascripts/form_validation.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/countries.js"></script>');
function validate(){
	// full_name
	if ($F('billing_profile_full_name').length<5){
		new Message("Add your full name.");
		$('billing_profile_full_name').focus();
		return false;
	}
	// address
	if ($F('billing_profile_address').length<1){
		new Message("Profile must have an address.");
		$('billing_profile_address').focus();
		return false;
	}
	//country
	if ($F('billing_profile_country').length != 2){
		new Message("Select a Country");
		$('billing_profile_country').focus();
		return false;
	}
	//city and state for non-us countries
	if ($F('billing_profile_country')!='us'){
		if ($F('billing_profile_city').length<1){
			new Message("Enter the city");
			$('billing_profile_city').focus();
			return false;
		}
		if ($F('billing_profile_state').length<1){
			new Message("Enter the state or province");
			$('billing_profile_state').focus();
			return false;
		}
	}
	//postal code
	if ($F('billing_profile_country')=='us' && $F('billing_profile_postal_code').length!=5){
		new Message( "Enter your postal code");
		$('billing_profile_postal_code').focus();
		return false;
	}
	//post form to server and return id
	post_form_via_ajax();
	return false;
}

function update_pay_page(){
	//#{bp.full_name} (#{bp.title}), #{bp.address}, #{bp.city}, #{bp.state} #{bp.postal_code}

	$('content').hide();
	$('message').hide();
	$('main').appendChild($B('center',[
		$B('a', {href:'#', onclick: 'parent.win.destroy();return false;'}, $F('billing_profile_full_name')+' ('+$F('billing_profile_last_4_numbers')+') ' + " has been added. Click to close this window.")
	]));
}

function post_form_via_ajax(){
	new Ajax.CustomRequest('/billing_profile/create', {
		postBody: Form.serialize('create_form'),
		onSuccess: function(r){ 
			eval(r.responseText);
			parent.$('billing_profile_chosen').appendChild($B('option', { value: billing_profile.id}, $F('billing_profile_full_name')+ $F('billing_profile_address') + ', ' + $F('billing_profile_city') + ', ' + $F('billing_profile_state') + ' ' + $F('billing_profile_postal_code') ));
			setTimeout( function(){ parent.win.destroy(); }, 200);
		},
		onLoading: function(){}
	});
}

function validate_via_ajax(el){
	new Ajax.CustomRequest('/billing_profile/validate?name='+el.id+"&value="+el.value, {
		onSuccess: function(r){ eval(r.responseText) },
		onLoading: function(){}
	});
}

function zip_action(){
	if ($F('billing_profile_country') == "us"){
		Element.show("div_postal_code_form");
		Element.hide("city_state");
		$('billing_profile_city').value='';
		$('billing_profile_state').value='';
	} else if ($F('billing_profile_country').length == 2){
		Element.show("city_state");
		Element.hide("div_postal_code_form");
	} else {
		$('billing_profile_postal_code').value == "";
		Element.show("city_state");
		Element.hide("div_postal_code_form");
	}
	return true;
}

function get_zip_data(){
	opt = {
    postBody: 'postal_code='+$F('billing_profile_postal_code')+'&country='+$F('billing_profile_country'),
    onLoading:'',
		onSuccess:function(r){
			eval(r.responseText); 
			if(zFlag==true){
				$('billing_profile_city').value = city;
				$('billing_profile_state').value = state;
			} else {
				new Message( "The postal code ("+$F('billing_profile_postal_code')+") doesn't exist in our system.");
			}
		}
	}
	new Ajax.CustomRequest('/postal_code/find', opt);
}

var billing_profile_exist = false;