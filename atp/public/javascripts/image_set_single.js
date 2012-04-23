function update_comment_count() {
  this.comSize = $$('div.comment').length;
  if (this.comSize > 0){
    this.txt = this.comSize + ' comment' + ( this.comSize == 1 ? '.' :'s.' );
  } else {
    this.txt = "Be the first to comment!";
  }
  $('comment_count').update(" | <a href='#' onclick='new Effect.ScrollTo(\"comments\"); return false;'>" + this.txt + "</a>");  
}

Event.addBehavior({
  "ul.star-rating li a:click": function(event) {
      Rate.post(this); return false;
  },
  "div.comment p.vote a:click": function(event) {
      Vote.post(this); return false;
  },
  "div#comments": function(event) {
      update_comment_count();
  }
});

Event.onReady(function() {
  if ($$('#pic_nav_prev a').length == 1){
    $$('div#explorepics p.prev2 a')[0].href = $$('#pic_nav_prev a')[0].href;
  }
  if ($$('#pic_nav_next a').length == 1){
    $$('div#explorepics p.next2 a')[0].href = $$('#pic_nav_next a')[0].href;
  }
});