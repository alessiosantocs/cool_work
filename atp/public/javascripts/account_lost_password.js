function sendPassword(form){
		new Ajax.CustomRequest(form.action, {
			postBody: Form.serialize(form.id),
			onLoading: function(){},
			onSuccess: function(r){
				new Message(r.responseText, 'good');
			},
			on400: function(r) { 
				if (r.responseText.length > 0){ new Message(r.responseText); } 
			}
		});
}