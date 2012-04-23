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
		$('subnav').toggle()
	},
  "a" : function(element) {
    var internalLinkRegexpArray = [ new RegExp('^https?://[^/]*alltheparties\.com', 'i') ];
    var url = element.href.toLowerCase(); /* Get the HREF for this link and convert to lower case */
    if (url.substr(0, 4) != 'http') { return; } /* Skip if a relative URL (doesn't start with http) */
    /* Loop through all the internal link regular expressions */
    for (var i=0; i < internalLinkRegexpArray.length; i++) { /* Check for a match with this regular expression */
      if (url.match(internalLinkRegexpArray[i])) {
      	return; /* Got a match, so it's an internal link and we're done */
      }
    }
    /* If we get here it's an external link */
    /* Add an onclick event to the link     */
    element.onclick = function(){
      var url = "/click?url=" + encodeURIComponent(this.href);
      location.href = url;
      return false;
    }
  }
});

C(Q(".new_window"), "click", function(ev){
  var el = ev.target;
  create_new_window({href: el.href});
  ev.preventDefault();
});