/*
Dojo Begins
*/
D.declare("Notice", null, {
  constructor: function(args){
    this.dialog = new dijit.Dialog(args);
  },
  clear: function(){
    this.dialog.hide();
  },
  set: function(text){
    this.class_name = (arguments.length == 2 ? arguments[1] : "notice");
    this.node = D.create("div", { innerHTML:text, className: this.class_name + '_ajax_response' });
    this.dialog.setContent(this.node);
    this.dialog.show();
  } 
});

// D.addOnLoad(function(){
//   try{
//     App.notice = new Notice({id: "atp_notice", style: "z-index: 2000;"});
//   } catch(e){}
// });

/*
Dojo ends
*/
if (Prototype.Browser.IE == true){
  Object.extend(Ajax.Request.prototype,{
    isSameOrigin: function() {
      try{
        var m = this.url.match(/^\s*https?:\/\/[^\/]*/);
      } catch(e){}
      return !m || (m[0] == '#{protocol}//#{domain}#{port}'.interpolate({
        protocol: location.protocol,
        domain: document.domain,
        port: location.port ? ':' + location.port : ''
      }));
    }
  });
}

Object.extend(Array.prototype, {
  sum: function(initial) {
    return this.inject(initial || 0, function(x, y) {return x + y;});
  },

  random: function(range) {
    var i = 0;
    if (!range) range = this.length;
    else if (range > 0) range %= 1;
    else i = range; range = this.length + range % this.length;
    return this[Math.floor(range * Math.random() - i )];
  },

  shuffle: function(deep) {
    var i = this.length;
    var clone = this.toArray();
    while (i) {
      j = Math.floor((i--) * Math.random());
      t = deep && clone[i].shuffle === undefined ? clone[i].shuffle() : clone[i];
      clone[i] = clone[j];
      clone[j] = t;
    }
    return clone;
  },

  unique: function() {
    var result = [];
    for (i = 0; i < this.length; i++) {
      if (result.indexOf(this[i]) < 0 ) result.push(this[i]);
    }
    return result;
  }
});

function $W(id,content){ replaceHtml(id,content.toString()); }
function $B(el) { return Builder.node(el, arguments[1] || {}, arguments[2] || ''); }
function $BB(html) { return Builder.build(html); }
function ping(url){ new Ajax.Request(url,arguments[1] || {}); }
function variable_loaded(variable){
  try {
    if (eval(variable)){
      return true;
    }
  } catch (e) {
      return false;
  }
}
//send & receive ajax
// Ajax.CustomRequest('/msgs', {postBody:'friends=3'});
Ajax.CustomRequest = Class.create();
Ajax.CustomRequest.prototype = Object.extend(new Ajax.Request(), {
  initialize: function(url) {
		if (arguments.length == 2){
			options=arguments[1];
		} else {
			options={};
		}
    this.setOptions(options);
    new Ajax.Request(url,this.options);
  },
  setOptions: function(options) {
    this.options = {
      method: 'post',
      asynchronous: true,
      parameters: '',
	    postBody: '', 
			onSuccess:function(r){
				if (r.responseText.length > 0){ new Message(r.responseText, 'good'); }
			},
    	onFailure: function() { new Message("Site is busy. Please try again later."); },
    	on400: function(r) {
				if (r.responseText.length > 0){ new Message(r.responseText); }
	    }
    };
	  Object.extend(this.options, options || {});
  }
});

/**************************************
» Jonas Raoni Soares Silva
» http://www.joninhas.ath.cx
**************************************/
String.prototype.capitalize = function(){ //v1.0
    return this.replace(/\w+/g, function(a){
        return a.charAt(0).toUpperCase() + a.substr(1).toLowerCase();
    });
};
String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };
String.prototype.stripPunctuation = function() {
	marks = " .,;!#$/:?'()[]_-\\\"";
	str = this;
	
	for (i = 0; i < marks.length; i++) {
	
		mark = marks.charAt(i);
	
		while (str.indexOf(mark) != -1) {
			point = str.indexOf(mark);
			first_part = str.substring(0, point);
			second_part = str.substring(point + 1, str.length);
			str = first_part + second_part;
		}
	}
	return str;
};

function build_redirect_link(obj, id, content){
  return $B('a', { href: "/r/l/"+obj+"/"+id }, [content]);
}

var Money = Class.create();
Money.regExp = new RegExp(/(\-?\d+(\.(\d+))?)/);
Money.prototype = {
  initialize: function(cents) {
    this.cents = cents || 0;
  },

  format: function() {
    if(this.cents == 0) return 'free';
    return '$' + this.toString();
  },

  toString: function() {
    // boy it sure would be nice if javascript had sprintf
    var s = (this.cents / 100).toString();
    var p = s.indexOf('.');
    if(p > -1) {
      var n = 3 - (s.length - p);
      for(var i = 0; i < n; i++) {
        s = s + '0';
      }
    } else {
      s = s + '.00';
    }
    return s;
  },

  toMoney: function() {
    return this;
  }
};

Number.prototype.toMoney = function() {
  return new Money(this * 100);
};

String.prototype.toMoney = function() {
  var matches = Money.regExp.exec(this);
  return new Money(matches ? Number(matches[0]) * 100 : 0);
};

function status_loading() {
  arguments.length == 0 ? this.id = 'message' : this.id = arguments[0];
	$W(this.id, App.loadingImage);
	$(this.id).show();
};

function create_new_window(args){
  var dialog = new dijit.Dialog(args);
  dialog.show();
  return dialog;
};

function createSelect(id, name, value, datasource, destination){
	$(destination).appendChild($B('select', {id: id, name: name}, ""));
	this.i = 0;
	datasource.each(function(t){ 
		$(id).appendChild($B('option',{value: t[0]}, t[1]));
		if (value==t[0]) { this.selectedIndex = this.i; }
		this.i++;
	});
	if (this.selectedIndex > 0){
		$(id).selectedIndex = this.selectedIndex;
	}	
}

function formatFullDate(postTime) {
	postTime=new Date(postTime);
	var month=['January','February','March','April','May','June','July','August','September','October','November','December'];
	var postYear=postTime.getYear();
	if (postYear<1900) postYear+=1900;
	return month[postTime.getMonth()]+' '+postTime.getDate()+", "+postYear;
}

function timeDifference(postTime) {
   if (!serverTime || serverTime<postTime) return formatFullDate(postTime);
   
   var ago=Math.floor((serverTime-postTime)/(1000*60)); // Posted ago in whole minutes rounded down
   if (ago>(60*24)) return formatFullDate(postTime); // Skip if more than 24 hours
   
   var hoursAgo=Math.floor(ago/60); //Whole hours = total minutes/(60min/hour) rounded down
   var minutesAgo=ago%60;           //Minutes = the remainder

   var message='';
   if (hoursAgo) {
      message+=hoursAgo+" hour";
      if (hoursAgo>1) message+="s";
      if (minutesAgo) message+=", ";
   }
   if (minutesAgo) {
      message+=minutesAgo+" minute";
      if (minutesAgo>1) message+="s";
   }
   if (message.length == 0) {
   		message = 'seconds';
   }
   message+=" ago";
   return message;
}

var Auth = {
  got_user_data: false,
  current_user: {},
	cookie: 'current_user',
	greeting: 'Hey',
  current_city: function(){ return D.cookie("city"); },
  logged_in: function(){
    return this.current_user.name != "Stranger"
  },
	get_user_data: function(){
	  if (!this.got_user_data){
      if (D.cookie(App.userCookie) == null){
  	    this.current_user.name = "Stranger";
  	  } else {
    	  try{
  	      this.current_user = dojo.fromJson(D.cookie(App.userCookie));
    	  } catch(e){
    	    D.cookie(App.userCookie) == null ? this.data = '' : this.data = D.cookie(App.userCookie);
      	  this.tmp = this.data.split(/%3B/);
      	  if (this.tmp.length == 4){
          	this.current_user.name = this.tmp[0];
          	this.current_user.country = this.tmp[1];
          	this.current_user.postal_code = this.tmp[2];
          	this.current_user.id = this.tmp[3];
          } else {
            this.current_user.name = "Stranger";
          }
    	  }
  	  }
  	  this.got_user_data = true;
  	}
	},
  check: function() {
    if (!this.logged_in()){
      $('dash').insertBefore(
        $B('form', { action: '/account/login', id: 'login', method: 'post', onsubmit: "Auth.logout();"}, [
  				$B('input', { type: 'text', name: 'user[username]', id: 'user_username', maxlength: 20, size: 12, value: 'Username', onfocus: "if (this.value=='Username') this.value='';"} ),
  				$B('input', { type: 'hidden', name: 'url', id: 'url', value: document.location }),
  				$B('input', { type: 'password', name: 'user[password]', id: 'user_password', maxlength: 20, size: 12, value: 'Password', onfocus: "if (this.value=='Password') this.value='';"}),
  				' ',
  				$B('input', { type: 'submit', name: 'submit', value: 'Login'})
  			]), $('usermenu'));
      this.msg = [
    		$BB("<li class='drop' id='place'><a href='#'>New York</a></li>"),
    		$BB("<li id='signup'><a href='" +  "/account/create'>Sign Up Now</a></li>"),
    		$BB("<li class='last'><a href='" +  "/account/lost_password' onclick='Auth.toggle_lost_password(); return false;'>Forgot Password?</a></li>")
    	];
    } else {
    	this.msg = [
    		$BB("<li id='user'>" + this.greeting + " <a href='/people/" + this.current_user.name + "'>" + this.current_user.name + "</a> <a href='#'><img src='/images/mail.gif' width='14' height='10' alt='mail' onclick=;Msg.show(); return false;' /></a></li>"),
    		$BB("<li class='drop' id='place'><a href='#'>New York</a></li>"),
    		$BB("<li><a href='" +  "/account/manage'>Manage Account</a></li>"),
    		$BB("<li><a onclick='return false;' href='#'>Help</a></li>"),
    		$BB("<li><a href='" +  "/account/logout'>Logout</a></li>"),
    		$BB("<li id='board' class='last'><a onclick='Auth.toggle_dashboard(); return false;' href='" +  "/account/dashboard'>Dashboard</a></li>")
    	];
    }
    this.msg.each(function(n){ $('usermenu').appendChild(n); });
  },
  login: function(user) {
    var show_message = arguments.length > 1 ? arguments[1] : true;
    this.current_user = user;
    Message.notice('Logged in as ' + Auth.current_user.login + '.');
  },
  logout: function() {
  	D.cookie(this.cookie, null, {expires: -1});
    new Message('Logged out successfully.', 'good');
    this.get_user_data();
  },
  /*post: function(){
		new Ajax.CustomRequest($('login_bar').url, {
			postBody: Form.serialize('login_bar'),
			onLoading: function(){},
			onSuccess: function(r){
				Auth.check();
			},
			on400: function(r) { 
				if (r.responseText.length > 0){ new Message(r.responseText); } 
			}
		});
  },*/
  toggle_dashboard: function(){
  	if (!$('dash-content')){
  		App.dashboard.clear();
			App.dashboard.show();
		} else {
  		App.dashboard.toggle();
  	}
  },
  toggle_lost_password: function() {
  	if (!$('lost_password_bar')){
  		App.dashboard.clear();
			App.dashboard.id.appendChild($B('form', {id: 'lost_password_bar', action: '/account/lost_password', method: 'post'}, [
				"Email Address: ",
				$B('input', { type: 'text', name: 'user[email]', id: 'user_email', maxlength: 70, size: 35}),
				' ',
				$B('input', { type: 'submit', name: 'submit', value: 'Email it'})
			]));
			App.dashboard.show();
			setTimeout(function(){ Form.focusFirstElement('lost_password_bar'); }, 50);
		} else {
  		App.dashboard.toggle();
  	}
  }
};

var Tag = {
	url: '', //This is set on the page it self
  post: function() {
		new Ajax.CustomRequest(Tag.url, {
			postBody: Form.serialize('tags_form'),
			onLoading: function(){},
			onSuccess: function(r){
				$('tags').update(r.responseText);
      	new Effect.Highlight('tags', { duration:1 });
				//new Message().clear();
				Tag.complete();
			},
			on400: function(r) { 
				if (r.responseText.length > 0){ new Message(r.responseText); } 
			}
		});
  },
  loading: function() {
    //Form.disable('tags_form');
    new Effect.Appear('new_tags_spinner', { duration:1 });
  },
  show: function() {
    new Effect.BlindDown('tags_form');
    new Effect.Fade('new_tags_link');
  },
  hide: function() {
    new Effect.BlindUp('tags_form', { duration:2 });
    new Effect.Appear('new_tags_link');
  },
  complete: function() {
    new Effect.Fade('new_tags_spinner', { duration:1 });
    Form.enable('tags_form');
    Tag.hide();
  }
};

var Rate = {
	cache: '',
  post: function(el) {
  	//get vars from url
  	split1 = el.href.split('/rate/');
  	obj_type = split1.last().split('/')[0];
  	obj_id = split1.last().split('/')[1];
  	
  	rate_class = $$('div.rate_'+obj_type+'_'+obj_id);
		new Ajax.CustomRequest(el.href, {
			onSuccess: function(r){
				//new Message().clear();
				rate_class.each(function(e){ 
					$(e).update(r.responseText);
					//new Effect.Highlight(e, { duration:1 });
				 });
				Rate.cache = r.responseText;
			},
			on400: function(r) { 
				if (r.responseText.length > 0){ 
					new Message(r.responseText); 
				} 
			}
		});
  }
};

var Vote = {
  post: function(el) {
  	vote_class = $(el).up();
		new Ajax.CustomRequest(el.href, {
			onLoading: function(){},
			onSuccess: function(r){
				//new Message().clear();
				vote_class.update(r.responseText);
      	new Effect.Highlight(vote_class, { duration:1 });
			},
			on400: function(r) {
				if (r.responseText.length > 0){ 
					new Message(r.responseText); 
				} 
			}
		});
  }
};

var Fave = {
  post: function(el) {
  	new Ajax.CustomRequest(el.href, {
  	  onComplete: function(){ TransparentMenu.hide('message'); },
			onLoading: function(){},
			onSuccess: function(r){
				new Message(r.responseText, 'good');
			},
			on400: function(r) { 
				if (r.responseText.length > 0){ 
					new Message(r.responseText);
				} 
			}
		});
  }
};

var Flag = {
  post: function(el) {
  	new Ajax.CustomRequest(el.href, {
			onLoading: function(){},
			onSuccess: function(r){
				new Message(r.responseText, 'good');
				//new Effect.FadeKeepSpace('comment_'+el);
			},
			on400: function(r) { 
				if (r.responseText.length > 0){ 
					new Message(r.responseText);
				} 
			}
		});
  }
};

//rails weenie
var Comment = {
  Create: {
    show: function() {
      new Effect.BlindDown('comment_form');
      new Effect.Fade('new_comment_link');
      Form.focusFirstElement('comment_form');
    },
  
    hide: function() {
      new Effect.BlindUp('comment_form', { duration:2 });
      new Effect.Appear('new_comment_link');
    },

    loading: function() {
      new Effect.Appear('new_comment_spinner', { duration:1 });
    },
        
    post: function() {
      this.status = FCG.message.init('commentStatus');
      this.comment_nodes = $('comments').immediateDescendants();
    	if (this.comment_nodes.length > 0){
    		var last_comment_id = this.comment_nodes.last().id.split(/_/).last();
    	} else {
    		var last_comment_id = 0;
    	}
			new Ajax.CustomRequest('/comment/new/'+$F('comment_commentable_type')+'/'+$F('comment_commentable_id'), {
				postBody: Form.serialize('comment_form')+'&last_comment_id='+last_comment_id,
				onSuccess: function(r){
					new Insertion.Bottom($('comments'), r.responseText);
					//this.highlight_from(last_comment_id);
					Comment.Create.complete();
				},
				onLoading: function(){},
				on400: function(r) { 
					if (r.responseText.length > 0){
						this.status.set(r.responseText);
						new Effect.Fade('new_comment_spinner', { duration:1 });
					}
				}
			});
    },
    complete: function() {
      new Effect.Fade('new_comment_spinner', { duration:1 });
      new Effect.Highlight($('comments').down(), { duration:2 });
      Form.reset('comment_form');
      Form.enable('comment_form');
      this.status.reset();
    }
  }/*,
  highlight_from: function(start_at) {
    start_comment = $('comment_'+start_at);
    end_at = $('comments').immediateDescendants().last().id.split(/_/).last();
    
    new Effect.Highlight(start_comment, { duration:2 });
    
  }*/
};

var Msg = {
	all_msgs: [],
	unread_msgs: 0,
	msgs_in_inbox: 0,
	msgs_in_sent: 0,
	offset: 0,
	limit: 5,
	current: {},
	folder: '',
	render_folder: function(){
		$('mail_'+Msg.folder).update('');
		if (Msg.all_msgs.length > 0){
			txt = Msg.all_msgs.collect(function(rec){
			  if (Msg.folder=='inbox' && rec.read == false){
			    row_class  = 'unread';
			  } else {
			    row_class  = 'read';
			  }
			  if (Msg.folder=='inbox'){
			    msg_user = rec.sender;
			  } else {
			    msg_user = rec.receiver;
			  }
				return $B('tr', { onmouseover: "this.style.backgroundColor='#CCCCCC'", onmouseout: "this.style.backgroundColor='#FFFFFF'", className: row_class }, [
					$B('input', { type: 'checkbox', name: 'msg[id]['+rec.id+']', id: 'msg_id_'+rec.id, value: 1 }),
					$B('td', { onclick: 'Msg.show_view(' + rec.id + '); return false;' }, msg_user),
					$B('td', { onclick: 'Msg.show_view(' + rec.id + '); return false;' }, rec.subject),
					$B('td', { onclick: 'Msg.show_view(' + rec.id + '); return false;', nowrap: 'nowrap' }, timeDifference(rec.time))
				]);
			});
		} else {
			txt = $B('tr', { valign: 'top' }, [
					$B('td', { colspan: 4, align: 'center' }, "No Mail")
				]);
		}
		this.start = 1 + new Number(Msg.offset);
		this.end = Msg.all_msgs.length + new Number(Msg.offset);
		if (Msg.folder == 'inbox'){
		  this.msg_count = Msg.msgs_in_inbox;
		} else {
		  this.msg_count = Msg.msgs_in_sent;
		}
		
		
		if (this.msg_count > Msg.offset + Msg.limit){
			//more msgs than shown
			this.next = $B('a', {href: '#', onclick: "Msg.get('" + Msg.folder + "', "+ ( Msg.offset + Msg.limit ) +"); return false;"}, ' Older » ');
		} else {
			this.next = "";
		}
		
		if (Msg.limit <= Msg.offset){
			this.previous = $B('a', {href: '#', onclick: "Msg.get('" + Msg.folder + "', "+ ( Msg.offset - Msg.limit ) +"); return false;"}, ' « Newer ');
		} else {
			this.previous = "";
		}
		
		$('mail_'+Msg.folder).appendChild($B('p', [
				$B('div', {style: 'float: right'}, [
					this.previous,
					(this.msg_count > 0 ? this.start + ' - ' + this.end + ' of ' + this.msg_count : ''),
					this.next
				] ),
				$B('input', { type: 'button', name: 'submit', value: 'Delete', onclick: "Msg.update_folder('current_"+Msg.folder+"', 'Delete'); return false;"}),
				$B('input', { type: 'button', name: 'submit', value: 'Report Spam', onclick: "Msg.update_folder('current_"+Msg.folder+"', 'Report Spam'); return false;"}),
				$B('form', {id: 'current_'+Msg.folder}, [
					$B('table', [
						$B('tr', [
							$B('th', { width: '1%'}),
							$B('th', { width: '9%'}, (Msg.folder=='inbox' ? 'From ' : 'To ' )),
							$B('th', { width: '80%'}, 'Subject'),
							$B('th', { width: '10%'}, 'Time')
						]),
						txt
					])
				])
			])
		);
		new Effect.Appear('mail_'+Msg.folder);
	},
	update_folder: function(form, action){
		new Ajax.Request('/msg/list?offset='+Msg.offset+'&folder='+Msg.folder, {
			method: 'post',
			postBody: Form.serialize(form)+'&submit='+action,
			onSuccess: function(r){
				eval(r.responseText);
				Msg.render_folder();
			}
		});
	},
	get: function(folder){
		Msg.folder = folder;
		if (arguments.length == 2){
			Msg.offset = arguments[1];
		} else {
			Msg.offset = 0;
		}
		new Ajax.Request('/msg/list?offset='+Msg.offset+'&folder='+Msg.folder, {
			method: 'get',
			onSuccess: function(r){
				eval(r.responseText);
				Msg.render_folder();
			}
		});
	},
	send: function(){
		new Ajax.Request('/msg/create', {
			postBody: Form.serialize('mail_compose_form'),
			method: 'post', 
			onSuccess: function(r){
				Form.reset('mail_compose_form');
				new Message(r.responseText, { id: 'message_mail', type: 'good'});
				Msg.show_inbox();
			},
			onFailure: function(r){
				new Message(r.responseText, { id: 'message_mail'});
			}
		});
	},
	do_this: function(id,act){
		new Ajax.Request('/msg/list/' + id +'?offset='+Msg.offset+'&folder='+Msg.folder+'&do='+act, {
			method: 'get',
			onSuccess: function(r){
				eval(r.responseText);
				switch(act){
					case 'drop':
						new Message("Message Deleted.", { id: 'message_mail', type: 'good'});
						break;
					case 'flag_as_spam':
						new Message("Message Deleted and Recorded as SPAM.", { id: 'message_mail', type: 'good'});
						break;
				}
				$('mail_view').hide();
				Msg.render_folder();
			},
			onFailure: function(r){
				new Message(r.responseText, { id: 'message_mail' });
			}
		});
	},
	reply: function(id){
		Msg.show_compose();
		$('msg_username').value = Msg.current.sender;
		$('msg_parent_id').value = id;
		$('msg_subject').value = "Re: " + Msg.current.subject;
	},
	forward: function(id){
		Msg.show_compose();
		$('msg_subject').value = "Re: " + Msg.current.subject;
		$('msg_message').value = Msg.current.message;
	},
	show_compose: function(){
		$('mail_sent').hide();
		$('mail_view').hide();
		$('mail_inbox').hide();
		new Effect.SlideDown('mail_compose');
		Form.focusFirstElement('mail_compose_form');
	},
	show_inbox: function(){
		Msg.get('inbox');
		$('mail_sent').hide();
		$('mail_view').hide();
		$('mail_compose').hide();
	},
	show_sent: function(){
		Msg.get('sent');
		$('mail_inbox').hide();
		$('mail_view').hide();
		$('mail_compose').hide();
	},
	show_view: function(id){
		Msg.current = Msg.all_msgs.find(function(rec) { return rec.id == id; });
		$('mail_view').update('');
		$('mail_inbox').hide();
		$('mail_sent').hide();
		$('mail_compose').hide();
		$('mail_view').appendChild($B('div', [
			$B('p', [
				$B('a', { href: '#', onclick: 'Msg.show_' + Msg.folder + '(); return false;'}, '« Back to '+ Msg.folder)
			]),
			$B('h2', Msg.current.subject ),
			$B('p', { className: 'stronger' }, (Msg.folder=='inbox' ? 'From: ' + Msg.current.sender : 'To: ' + Msg.current.receiver ) + ' (' + timeDifference(Msg.current.time) + ')' ),
			$B('p', [
				$B('a', { href: '#', onclick: 'Msg.reply(' + Msg.current.id + '); return false;'}, 'Reply'),
				' | ',
				$B('a', { href: '#', onclick: 'Msg.forward(' + Msg.current.id + '); return false;'}, 'Forward'),
				' | ',
				$B('a', { href: '#', onclick: 'Msg.do_this(' + Msg.current.id + ', \'flag_as_spam\'); return false;'}, 'Report Spam'),
				' | ',
				$B('a', { href: '#', onclick: 'Msg.do_this(' + Msg.current.id + ', \'drop\'); return false;'}, 'Delete')
			]),
			$B('p', Msg.current.message )
		]));
		new Effect.Appear('mail_view');
		if (Msg.current.read == false && Msg.folder == 'inbox'){
			ping('/msg/read/'+id);
		}
	},
	show: function(){
		if (!$('mail_bar')){
			App.dashboard.clear();
			App.dashboard.id.appendChild($B('div', {id: 'mail_bar'}, [
				$B('h4', "Message Center"),
				$B('div', { id: 'message_mail', style: 'display:none;' }),
				$B('table', [
					$B('tr', [
						$B('td', { width: '10%', valign: 'top'}, [
							$B('ul', [
								$B('li', { className: 'folder'}, [
									$B('a', { href: '#', onclick: "Msg.show_compose(); return false;"}, "Compose")
								]),
								$B('li', { className: 'folder'}, [
									$B('a', { href: '#', onclick: "Msg.show_inbox(); return false;"}, "Inbox")
								]),
								$B('li', { className: 'folder'}, [
									$B('a', { href: '#', onclick: "Msg.show_sent(); return false;"}, "Sent")
								])
							])
						]),
						$B('td', { width: '90%', valign: 'top'}, [
							$B('div', {id: 'mail_compose', style:'display:none;'}, [
								$B('form', {id: 'mail_compose_form', onsubmit: 'Msg.send(); return false;'}, [
									"To: ",
									$B('input', { type: 'text', name: 'msg[username]', id: 'msg_username', maxlength: 12, size: 14}),
									$B('br'),
									"Subject: ",
									$B('input', { type: 'text', name: 'msg[subject]', id: 'msg_subject', maxlength: 128, size: 75}),
									$B('br'),
									"Message: ",
									$B('br'),
									$B('textarea', { cols: 110, rows: 10, name: 'msg[message]', id: 'msg_message', maxlength: 128, size: 75}),
									' ',
									$B('input', { type: 'submit', name: 'submit', value: 'Send'}),
									$B('input', { type: 'hidden', name: 'msg[parent_id]', id: 'msg_parent_id'}),
									$B('button', { href: '#', onclick: "Form.reset('mail_compose_form'); return false;"}, "Cancel")
								])
							]),
							$B('div', {id: 'mail_inbox', style:'display:none;'}),
							$B('div', {id: 'mail_sent', style:'display:none;'}),
							$B('div', {id: 'mail_view', style:'display:none;'})
						])
					])
				])
			]));
			App.dashboard.show();
			Msg.show_inbox();
		} else {
  		App.dashboard.toggle();
  	}
	},
	hide: function(){
		
	}
};

var Message = Class.create();
Message.prototype = {
	initialize: function(msg) {
    this.options = {
      id: 	'message',
      type: 'bad'
    };
		if (msg){
			if (arguments.length == 2){
				if ( typeof arguments[1] == 'string'){
					this.options.type = arguments[1];
				} else {
			    Object.extend(this.options, arguments[1] || {});
				}
		    this.options.id = $(this.options.id);
				switch(this.options.type){
					case 'good':
						this.options.type = 'good';
						break;
					case 'notice':
						this.options.type = 'notice';
						break;
					default:
						this.options.type='bad';
						break;
				}
			}
	    this.set(msg, this.options.type+'_ajax_response');
	    if (this.options.type=='bad'){
	    	new Effect.ScrollTo(this.options.id);
	    }
		}
	},
	
  clear: function() {
    try {
      ID(this.options.id).hide();
    } catch (e) {
      return false;
    }
    
  },

  set: function(text, class_name) {
    if(!this.options.id) return;
    this.options.id = $(this.options.id);
    this.options.id.innerHTML = text;
    this.options.id.className = class_name;
    this.options.id.show();
  }
};

FCG.message = {
  elementId: 'message',
  state: 'bad',
  suffix: '_ajax_response',
  renderNode: function(d,cls,txt){
    var el = $(this.elementId);
    el.style.display = d || 'none';
    el.className = cls || '';
    $W(el, txt || '');
  },
  reset: function(){
    this.renderNode();
    $(this.elementId).show();
  },
  init: function(el){
    this.elementId = el || this.elementId;
    return this;
  },
  set : function(text, st, el, suf){
    this.elementId = el || this.elementId;
    this.state = st || this.state;
    this.suffix = suf || this.suffix;
    this.renderNode(this.elementId, this.state + this.suffix, text);
    $(this.elementId).show();
    if (this.state=='bad'){
    	new Effect.ScrollTo($(this.elementId));
    }
    return this;
  }
};

var Dashboard = Class.create();
Dashboard.prototype = {
	initialize: function(){
		this.ids = [$('dash'), $('wrap')];
		this.content_id = $('dash-content');
		this.id = this.content_id;
	},
	clear: function(){
		this.id.update('');
	},
	update: function(html){
		this.id.update(html);
	},
	show: function(){
	  this.ids.each(function(el) { el.setStyle({height: "280px"}); });
		this.id.show();
	},
	hide: function(){
		this.ids.each(function(el) { el.setStyle({height: "45px"}); });
		this.id.hide();
	},
	visible: function(){
		return (parseFloat(this.ids[0].getStyle('height')) > 45);
	},
	toggle: function(){
		this.visible() ? this.hide() : this.show();
	}
};

var Pic = Class.create();
Pic.prototype = {
	initialize: function(){
	  this.data = arguments[0];
	  if (arguments.length == 2)
	    this.render(arguments[1]);
	},
	url: function(){
	  if (arguments.length == 0)
	    return this.data.url + this.data.name + this.data.extension;
	  else
  	  return this.data.url + this.data.name + "_" + arguments[0] + this.data.extension;
	},
	render: function(size){
	  return $B("img", { src: this.url(size), alt: this.data.caption || "image", className:"image", id: "image_"+this.data.id } );
	}
};

// Enable/Disable next/previous buttons
function buttonStateHandler(button, enabled) {
 if (button == "prev-arrow") 
   $('prev-arrow').src = enabled ? "/images/prev-on.gif" : "/images/prev-off.gif";
 else 
   $('next-arrow').src = enabled ? "/images/next-on.gif" : "/images/next-off.gif";
}

// Anim effects before and after scrolling
function animHandler(carouselID, status, direction) {
  var region = $(carouselID).down(".carousel-clip-region");
  if (status == "before") {
    Effect.Fade(region, {from: 1, to: .35, queue: { position:'end', scope: "carousel" }, duration: 0.3});
  }
  if (status == "after") {
    Effect.Fade(region, {from: .35, to: 1, queue: { position:'end', scope: "carousel" }, duration: 0.3});
  }
}

function render_ads(adverts, n, orient){
	if (n < 1 ){
		return;
	} else {
	  if (n == 1){
	    adverts = [adverts.random()];
	  } else{
	    adverts = adverts.shuffle();
	  }
		document.write("<ul class='orient-" + orient + "'>");
		for (var i = 0; i < n; ++i){
		  if (adverts[i]){
		    ad = { src: adverts[i].src, url: adverts[i].url };
		  }
		  else {
		    ad = { src: '/images/na120x120.jpg', url: '#' };
		  }
		  document.write("<li><a href='"+  ad.url +"'><img src='" + ad.src + "' alt='ad' /></a></li>");
		}
		document.write('</ul>');
	}
}

function replaceHtml(el, html) {
  var oldEl = (typeof el === "string" ? document.getElementById(el) : el);
  var newEl = document.createElement(oldEl.nodeName);
  // Preserve the element's id and class (other properties are lost)
  newEl.id = oldEl.id;
  newEl.className = oldEl.className;
  // Replace the old with the new
  newEl.innerHTML = html;
  oldEl.parentNode.replaceChild(newEl, oldEl);
  /* Since we just removed the old element from the DOM, return a reference
  to the new element, which can be used to restore variable references. */
  return newEl;
};

D.declare("Location", null, {
  constructor: function(){
    this.city_name = App.subDomain();
    Auth.get_user_data();
    if (!Auth.logged_in()){
      return false;
    }
    
    if (this.city_name == "www"){
      this.city_id = 0;
    } else {
      dojo.some(App.cities, function(aryItem){
        if (aryItem["city"]["short_name"] === this.city_name){
          this.city_id = aryItem["city"]["id"];
          return true;
        }
      }, this);
    }
    
	  this.default_data = {
	    party_id: 0,
	    city_id: this.city_id,
	    image_set_id: 0,
	    event_id: 0,
	    user_id: Auth.current_user.id
	  };
	  
	  this.data = dojo.mixin(this.default_data, arguments[0]);
	  
	  dojo.xhrPost({
	    url: "/locations",
	    content: this.data,
	    handleAs: "json",
	    load: function(response, ioArgs){
	      return response;
	    },
	    error: function(response, ioArgs){
	      return response;
	    }
	  });
  }
});

Event.addBehavior({
 "div#wrap div#dash-content" : function() {
   App.dashboard = new Dashboard(this.id);
 },
 "a.fave_link:click" : function() { 
   Fave.post(this);
   return false;
 },
 "a.flag_link:click" : function() { 
   Flag.post(this);
   return false;
 },
 "span.money" : function() { 
   this.innerHTML = new Money(parseInt(this.innerHTML)).format();
 },
 "ul#usermenu li.drop:click" : function() { 
   $('subnav').toggle();
 }
});

C(Q(".new_window"), "click", function(ev){
  ev.preventDefault();
  var el = ev.target;
  create_new_window({href: el.href});
});

D.addOnLoad(function(){
  Auth.get_user_data();
});