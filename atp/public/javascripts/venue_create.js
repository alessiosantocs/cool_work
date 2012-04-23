document.write('<script type="text/javascript" src="/javascripts/form_validation.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/countries.js"></script>');
document.write('<script type="text/javascript" src="/javascripts/timezones.js"></script>');
function validate(){
	//  name
	if (F('venue_name').length<1){
		new Message("Venue must have a name.");
		ID('venue_name').focus();
		return false;
	}
	//country
	if (F('venue_country').length != 2){
		new Message("Select a Country");
		ID('venue_country').focus();
		return false;
	}
	// address
	if (F('venue_address').length<1){
		new Message("Venue must have an address.");
		ID('venue_address').focus();
		return false;
	}
	//city and state for non-us countries
	if (F('venue_country')!='us'){
		if (F('venue_city_name').length<1){
			new Message("Enter the city");
			ID('venue_city_name').focus();
			return false;
		}
		if (F('venue_state').length<1){
			new Message("Enter the state or province");
			ID('venue_state').focus();
			return false;
		}
	}
	//postal code
	if (F('venue_country')=='us' && F('venue_postal_code').length!=5){
		new Message( "Enter your postal code");
		ID('venue_postal_code').focus();
		return false;
	}
	//post form to server and return id
	post_form_via_ajax();
	return false;
}

function update_party(){
	parent.ID('venue_name').value = venue.name;
	parent.ID('party_venue_id').value = venue.id;
	ID('content').remove();
	$ID('body')[0].appendChild($B('center',[
		$B('a', {href:'#', onclick: 'parent.win.destroy(); return false;'}, venue.name+" has been added. click to close this window.")
	]));
}

function post_form_via_ajax(){
	new Ajax.CustomRequest('/venue/create', {
		postBody: Form.serialize('create_form'),
		onSuccess: function(r){ 
			eval(r.responseText);
			parent.ID('venue_name').value = venue.name;
			parent.ID('party_venue_id').value = venue.id;
			setTimeout( function(){ parent.win.destroy(); }, 200);
			//return false;
			//update_party();
		},
		onLoading: function(){}
	});
}

function validate_via_ajax(el){
	new Ajax.CustomRequest('/venue/validate?name='+el.id+"&value="+el.value, {
		onSuccess: function(r){ eval(r.responseText) },
		onLoading: function(){}
	});
}

function zip_action(){
	if (F('venue_country') == "us"){
		ID("div_postal_code_form").show();
		ID("city_state").hide();
		ID('venue_city_name').value='';
		ID('venue_state').value='';
	} else if (F('venue_country').length == 2){
		ID("city_state").show();
		ID("div_postal_code_form").hide();
	} else {
		ID('venue_postal_code').value =ID( "";
		ID("city_state").show();
		ID("div_postal_code_form").hide();
	}
}

function get_zip_data(){
	opt = {
    postBody: 'postal_code='+F('venue_postal_code')+'&country='+F('venue_country'),
    onLoading:'',
		onSuccess:function(r){
			eval(r.responseText); 
			setTimeout(function(){
				if(zFlag==true){
					ID('venue_city_name').value = city;
					ID('venue_state').value = state;
				} else {
					new Message( "The postal code ("+F('venue_postal_code')+") doesn't exist in our system.");
				}
			}, 250);
		}
	}
	new Ajax.CustomRequest('/postal_code/find', opt);
}

Event.addBehavior({
	"body" : function() { 
		if (F('venue_postal_code').length==5){ get_zip_data(); }
		zip_action();
		ID('venue_name').focus();
	}
});
var venue_exist = false;