function initCarousel_html_carousel() {
	  carousel = new Carousel('html-carousel', {
  		numVisible: 6,
  		scrollInc: 6,
  		animHandler:animHandler, 
  		animParameters:{duration:0.5}, 
  		buttonStateHandler:buttonStateHandler, 
  		nextElementID:'next-arrow', 
  		prevElementID:'prev-arrow', 
  		size: $$('#html-carousel ul.carousel-list li').length
  	});
  	this.params = document.location.search.toQueryParams();
  	if (this.params.at)
  	  carousel.scrollTo(this.params.at-1);
};

Event.onReady(function(){
  if ($$('#html-carousel ul.carousel-list li').length > 0){
    initCarousel_html_carousel();
  }
});