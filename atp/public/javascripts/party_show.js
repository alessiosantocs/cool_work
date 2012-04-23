function initCarousel_html_carousel() {
	  carousel = new Carousel('html-carousel', {
  		numVisible: 3,
  		scrollInc: 3,
  		animHandler:animHandler, 
  		animParameters:{duration:0.5}, 
  		buttonStateHandler:buttonStateHandler, 
  		nextElementID:'next-arrow', 
  		prevElementID:'prev-arrow', 
  		size: $$('#html-carousel ul.carousel-list li').length
  	});
};

function postRSVP() {
  new Ajax.CustomRequest($('rsvp_form').action, {
		postBody: Form.serialize('rsvp_form') + "&format=js",
		onSuccess: function(r){
		  new Message("RSVP Saved", "good");
		  $('rsvp_form').reset();
		},
		onFailure: function(r) { 
			if (r.responseText.length > 0){ new Message(r.responseText); } 
		}
	});
};

Event.onReady(function(){
  var title = $$("div#action h1 a")[0];
  title.update(title.innerHTML.toString().capitalize().truncate(35));
  if ($$('#html-carousel ul.carousel-list li').length > 0){
    initCarousel_html_carousel();
  }
  var rsvp_link = $$("ul#actionlinks li.drop");
  if (rsvp_link.length == 1){
    Element.hide(rsvp_link[0]);
  }
});

Event.addBehavior({
	"form#rsvp_form:submit" : function() {
	  postRSVP();
	  return false;
	}
});