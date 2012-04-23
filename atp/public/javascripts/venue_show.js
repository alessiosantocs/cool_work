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
Event.onReady(function(){
  if ($$('#html-carousel ul.carousel-list li').length > 0)
    initCarousel_html_carousel();
});

