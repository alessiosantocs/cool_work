Event.addBehavior({
  "div#secondaryContent p a.top_views:click" : function() {
    var  divs = ["sitewide25", "region10"];
    var links = ["site_name", "region_name"];
    if ($(divs[0]).visible()){
      $(divs[0], links[1]).invoke('hide');
      $(divs[1], links[0]).invoke('show');
    } else{  
      $(divs[1], links[0]).invoke('hide');
      $(divs[0], links[1]).invoke('show');
    }
	  return false;
  }
});