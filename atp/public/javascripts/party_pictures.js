function update_event_info(){
  $('event_form').hide();
  $('event_loading').show();
	opt = {
    postBody: Form.serialize("event_form"),
    onComplete:function(){
      $('event_form').show();
      $('event_loading').hide();
    },
		onSuccess:function(r){
			new Message(r.responseText, { id: 'event_status', type: 'good'});
		}
	}
	new Ajax.CustomRequest($('event_form').action, opt);
}

function update_order(){
	opt = {
    postBody: Sortable.serialize("image_set"),
		onSuccess:function(r){
			new Message(r.responseText, { id: 'action_status', type: 'good'});
		}
	}
	new Ajax.CustomRequest('/pictures/event/'+current_event+'/order', opt);
}

function sort_or_not(){
	if (sorting == true){
		Sortable.create("image_set", { constraint: false, onUpdate: function(){ update_order(); } });
	} else {
		Sortable.destroy("image_set");
	}
}

function get_event() {
  //redirect to event
 	if (parseInt($F('event_id')) > 0){
 	  if (current_event != parseInt($F('event_id'))){
   	  loc = location.pathname + "?event_id=" + $F('event_id');
   	  document.location.href = loc;
 	  }
 	} else {  
 	  $('event_tools').hide();
 	}
}

function flip_switches(el){
  el = $(el);
  switch (el.id){
    case "switch_event_info":
      this.element = 'event_form';
      break;
    case "switch_upload":
      this.element = 'upload_images';
      break;
    case "switch_arrange_images":
      this.element = 'current_images';
      break;
    case "switch_update_images":
      this.element = 'update_images';
      break;
  }
  Element.toggle($(this.element));
  if (el.innerHTML == '+'){
    txt='-';
  } else {
    txt='+';
  }
  $W(el.id, txt);
}  
Event.addBehavior({
  "form#update_form:submit": function(event) {
    $('update_form').hide();
    $('updating').show();
  },
  "form#upload_form:submit": function(event) {
    $('upload_form').hide();
    $('uploading').show();
  },
  "form#event_form:submit": function(event) {
    update_event_info();
    return false;
  },
  "select#event_id:change": function(event) {
    get_event();
  },
  "a.switch:click": function(event) {
    flip_switches(this.id);
    return false;
  },
  "ul#image_set li a:click": function(event) {
    return false;
  }
});
var current_event;
var sorting=true;