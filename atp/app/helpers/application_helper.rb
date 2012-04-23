# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include AdSystem
  include DojoHelper
  include SearchHelper
  
  def breadcrumb_div
    return if @breadcrumb.nil?
    <<-EOL
    <div id="breadcrumbs">#{@breadcrumb.print_trail()}</div>
    EOL
  end
  
  def server_time
    "<script type='text/javascript' language='javascript'>var serverTime=parseFloat("+ (("%10.5f" % Time.now.utc.to_f).to_f * 1000).to_s + ")</script>"
  end
  
  def get_map_system
    <<-EOL
    <script type="text/javascript">
    document.write(unescape("%3Cscript src='" + App.protocol + "api.maps.yahoo.com/ajaxymap?v=3.0&amp;appid="+App.yahooMapId()+"' type='text/javascript'%3E%3C/script%3E"));
    </script>
    EOL
  end
  
  def map_location(id, venue, level=1)
    address = "#{venue.address}, #{venue.city_name}, #{venue.state}, #{venue.postal_code}"
    html = venue.name
    <<-EOL
    <script type="text/javascript">
      function onSmartWinEvent(){
        var words = '<div style="width:80px;height:20px;">#{venue.address}</div>';
        marker.openSmartWindow(words);
      }
      var map = new YMap($('#{id}'));
      var html = "#{html}";
      var addr = "#{address}";
      map.addZoomLong();
      map.drawZoomAndCenter( addr, #{level} );
      marker = new YMarker(addr);
      var marker = new YMarker(addr);
      map.addOverlay(marker);
      YEvent.Capture(marker, EventsList.MouseClick, onSmartWinEvent);
    </script>
    EOL
  end
  
  def render_errors(obj)
    return "" unless obj
    if controller.request.post?
      tag = ""
      unless obj.valid?
        tag << %{<ul class="objerrors">}
        obj.errors.each_full do |message| 
          tag << "<li>#{message}</li>"
        end
        tag << "</ul>"
      end
      tag
    end
  end
  
  def render_flash
    tag = String.new
    unless flash.nil?
      for key,value in flash
        tag << %{<div id="flash_#{key}">#{value}</div>\n}
      end
    end
    "<div id='message'>#{tag}</div>"
  end
  
  def stylesheet_auto_link_tags
    stylesheets_path = "#{RAILS_ROOT}/public/stylesheets/" 
    candidates = [ "#{controller.controller_name}", "#{controller.controller_name}_#{controller.action_name}" ]
    candidates.inject("") do |buf, css| 
      buf << stylesheet_link_tag(css) if FileTest.exist?("#{stylesheets_path}/#{css}.css")
      buf
    end
  end
  
  def javascript_auto_link_tags
    javascripts_path = "#{RAILS_ROOT}/public/javascripts/" 
    candidates = [ "#{controller.controller_name}", "#{controller.controller_name}_#{controller.action_name}" ]
    candidates.inject("") do |buf, js| 
      buf << javascript_include_tag(js) if FileTest.exist?("#{javascripts_path}/#{js}.js")
      buf
    end
  end
  
  def traffic_tracker
	  <<-EOL
	  <script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
    try {
    var pageTracker = _gat._getTracker("UA-60874-2");
    pageTracker._trackPageview();
    } catch(err) {}</script>
    EOL
  end
  
  def searchbox
    <<-EOL
    <!-- Google CSE Search Box Begins -->
    <form id="searchbox_003979525011358546875:zf4nzoimyyq" action="/search/results">
      <input type="hidden" name="cx" value="003979525011358546875:zf4nzoimyyq" />
      <input name="q" type="text" size="20" id="searchbox" />
      <input type="submit" name="sa" value="Search" class="search" />
      <input type="hidden" name="cof" value="FORID:9" />
    </form>
    <script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_003979525011358546875%3Azf4nzoimyyq"></script>
    <!-- Google CSE Search Box Ends -->
    EOL
  end
  
  def auto_complete_result_with_callback(entries, fields=[], passed_var=nil)
    return unless entries and fields and passed_var
    return unless fields.length > 1
    #field = [section, value for text field,  value for hidden id]
    if entries.size > 0
      items = entries.map do |entry|
        content_tag("li", h(entry[fields.first]), { :title => "#{passed_var}:#{entry[fields.last]}"} )
      end
    else
      items = [ content_tag("li", h("No match found"), { :title => "no match found"} ) ]
    end
    content_tag("ul", items.uniq)
  end
	
  def fave_link(obj, txt = 'Add' )
    link_to txt, fave_url( :obj_id => obj.id, :obj_type => obj.class.to_s, :action => "add"), {:name=> "fave_#{obj.class}_#{obj.id}", :class => "fave_link"}
  end
  
  def flag_link(obj)
    status = { :inappropriate => nil, :spam => nil }
    case obj.class.to_s
      when 'Comment', 'Image'
        txt = "Flag as inappropriate"
        status[:inappropriate] = true
      when 'Msg'
        txt = "Flag as spam"
        status[:spam] = true
    end
    link_to(txt, { :controller => 'flag', :action => 'add', :obj_id => obj.id, :obj_type => obj.class.to_s, :inappropriate => status[:inappropriate], :spam => status[:spam] }, { :class => 'flag_link' } )
  end
	
	def tags_displayed(tags)
	  txt = tags.collect{ |t| "<a href='/tags/#{t}/'>#{t}</a>" }
	  txt.join('&nbsp;')
	end
	
  def people_link(u, photo=false)
    txt = u.username
    if photo ==true
      #i = u.image_sets[0].image
      i = ImageSet.get_first("User", u.id) rescue nil
      txt = image_tag(i.link('small'), {:alt=> txt }) unless i.nil?
    end
    link_to txt, people_url( :host => 'www' + ".#{SITE.url}", :username => u.username), {:name=> "user_#{u.id}", :class => "people_link"}
  end
	
  def venue_link(v)
    link_to v.name, venue_url( :id => v), {:name=> "venue_#{v.id}", :class => "venue_link"}
  end
	
  def party_link(p, flyer=false)
    link_to "#{p.title} at #{p.venue.name}", party_url(:host => "#{get_city_short_name(p.venue.city_id)}.#{SITE.url}", :id => p), {:name=> "party_#{p.id}", :class => "party"}
  end
	
  def event_image_set_link(e, txt=nil)
    link_to(txt || date_string(e.local_time), image_set_url(:host => get_city_short_name(e.venue.city_id) + ".#{SITE.url}", :obj_type => e.class.to_s.downcase, :obj_id => e.id), {:name=> "event_#{e.id}", :class => "event"})
  end

  def event_image_set_by_date(date)
    link_to(date_string(date), images_by_day_url(:year => date.strftime("%Y"), :month => date.strftime("%m"), :day => date.strftime("%d")))
  end
  
  def event_thumbnail(e)
    unless e.image_sets.empty?
      return '' if e.image_sets[0].nil?
      i = e.image_sets[0].image
      city_short_name = get_city_short_name(e.venue.city_id)
      txt = "#{date_string(e.local_time)}: #{e.party.title} at #{e.venue.name}"
      link_to(image_tag(i.link('small'), {:alt=> txt }) + "<span></span>", image_set_url(:host => "#{city_short_name}.#{SITE.url}", :obj_type => e.class.to_s.downcase, :obj_id => e.id), {:title => txt, :name=> "event_#{e.id}", :class=> "event_link"})
    end
  end

  def party_flyer(f)
    i = f.image
    case f.obj_type
      when 'Party'
        title = "#{f.obj.title} at #{f.obj.venue.name}"
        party = f.obj
        id = f.obj.id
        region = get_city_short_name(f.obj.venue.city_id)
      when 'Event'
        title = "#{f.obj.party.title} at #{f.obj.venue.name}"
        id = f.obj.party_id
        party = f.obj.party
        region = get_city_short_name(f.obj.venue.city_id)
      else
        return nil
    end
    link_to(image_tag(i.url, {:alt=> title, :size => "#{i.width}x#{i.height}"}), party_url(:id => p), {:name=> "party_#{id}", :class=> "party"})
  end
  
  def show_comment(comment, voteable=true)
    <<-EOL
    <div class="comment" id="comment_#{comment.id}">
      <div class="avatar">
        <p class='vote'>#{show_vote(comment)}</p>
        <p class='flag'>#{flag_link(comment)}</p>
      </div>

      <div class="comment-content">
        <p style="clear:both">#{people_link(comment.user)}<br/>
        <span class="date">#{comment.created_at}</span></p>
        <p>#{h comment.comment}</p>
      </div>
    </div><!-- comment -->
    EOL
  end
  
  def show_comments(comments, voteable=true)
    txt = comments.collect { |c| show_comment(c, voteable) }
    txt.to_s
  end
  
  def show_vote(vote)
    obj_type = vote.class.to_s.downcase
    <<-EOL
    #{link_to vote.votes_for, vote_for_path( :obj_type => obj_type, :obj_id => vote.id ), { :class => 'vote_for' }}
    #{link_to vote.votes_against, vote_against_path( :obj_type => obj_type, :obj_id => vote.id ), { :class => 'vote_against' }}
    EOL
  end
  
  def image_not_available(type, opt={})
    options = {
      :id => nil,
      :class => nil    
    }.merge(opt)
    size = Image.get_size(type)
    image_tag("na#{size.join('x')}.jpg", options)
  end
  alias :img_na :image_not_available
  
  def show_regions
    items = REGIONS.map do |r|
      content_tag("li", content_tag("a", r.full_name, {:href=> "http://#{r.short_name}.#{SITE.url}" }) )
    end
    content_tag("ul", items.uniq, {:id => 'subnav', :style=> "display:none;"})
  end
  
  def automatic_window_close(msg, seconds=5)
    <<-EOL
    <script>
    // <![CDATA[
    setTimeout("self.close()", #{seconds*1000});
    document.write('<h2>#{msg}</h2><p><a href="#" onclick="self.close();return(false);">Window will close in #{seconds} seconds)</a></p>');
    // ]]>
    </script>
    EOL
  end
  
  def google_ajax_library
    <<-EOL
    <script src="http://www.google.com/jsapi"></script>
    
    <script type="text/javascript">
      // <![CDATA[
      // document.write(unescape("%3Cscript src='"+App.protocol+"www.google.com/jsapi' type='text/javascript'%3E%3C/script%3E"));
      // ]]>
    </script>
    <script type="text/javascript">
      // <![CDATA[
      google.load("prototype", "1.6.0.3"); google.load("scriptaculous", "1.8.2");
      // ]]>
    </script>
    EOL
    
    javascript_include_tag "prototype", "scriptaculous"
  end
  
  def javascript_constants
    <<-SCRIPT
    <script type="text/javascript">
    // <![CDATA[
    /*
    App Data
    Changeable
    */
    var App =  {
      baseDomain: "#{SITE.url}",
      cities: #{City.active.to_json},
      cookie: { expires_in_days: 365 },
      dashboard: "",
      getNewId: function() {
        return "atp_id_" + App.lastId++;
      },
      lastId: 0,
      loadingImage: "<img src='/images/ajax-loader-white.gif' height='19' width='220' alt='loading' class='loading' />",
      protocol: (("https:" == document.location.protocol) ? "https://" : "http://"),
      sessionCookie: '_session_id',
      sessionLifeSpan: 1800000, //30 mins
      subDomain: function(){
        var d = document.location.hostname.split('.');
        if (d.length == 3){
          return d[0].substr(0,3);
        }
      },
      userCookie: 'current_user',
      yahooMapId: function(){
        return (['scenestr', 'scenstr5', 'testbase', 'scenestr.com', 'anc_production'].random());
      }
    };

    /*
    SD is short for SiteData 
    For Constants only
    */
    if (!SD) { var SD = new Object(); };
    SD = {
      version: "0.20",
      trueOrFalse: [ [0, 'false'], [1, 'true'] ],
      image: {
      	size: { 
      	  large: [480,480], 
      	  small: [100,100], 
      	  tiny: [50,50], 
      	  tiny: [16,16]
      	}
      },
      roles: [ ['User', 'User'], ['Promoter', 'Promoter/Photographer'] ],
      validate: {
      	time: function(s) { 
      		return (/^(0?[1-9]|1[0-2]):(00|15|30|45)(AM|am|PM|pm)$/).test(s); }
      }
    };

    if (!FCG) { var FCG = new Object(); };
    // ]]>
  </script>
  SCRIPT
  end
  
  def sharethis_widget
    <<-EOL
    <script type="text/javascript" src="http://w.sharethis.com/widget/?tabs=email%2Cweb%2Cpost&amp;charset=utf-8&amp;style=rotate&amp;publisher=c0d8a759-d20c-47e5-b291-b43b983081f3"></script>
    EOL
  end
  
  def main_video_player
    <<-HTML
    <!-- START Vimeo Badge ... info at http://vimeo.com/widget -->
    <style type="text/css">
    <!-- 
    /* You can modify these CSS styles */
    .vimeoBadge { margin: 0; padding: 0; font: normal 11px verdana,sans-serif; }
    .vimeoBadge img { border: 0; }
    .vimeoBadge a, .vimeoBadge a:link, .vimeoBadge a:visited, .vimeoBadge a:active { color: #3A75C4; text-decoration: none; cursor: pointer; }
    .vimeoBadge a:hover { color:#00CCFF; }
    .vimeoBadge #vimeo_badge_logo { margin-top:10px; width: 57px; height: 16px; }
    .vimeoBadge .credit { font: normal 11px verdana,sans-serif; }
    .vimeoBadge .clip { padding:0; float:left; margin:0 10px 10px 0; width:160px; line-height:0; }
    .vimeoBadge .caption { font: normal 11px verdana,sans-serif; overflow:hidden; width:160px; height: 30px; }
    .vimeoBadge .clear { display: block; clear: both; visibility: hidden; } 
    -->
    </style>
    <div class="vimeoBadge">
      <script type="text/javascript" src="http://vimeo.com/alltheparties/badgeo/?stream=uploaded&amp;stream_id=&amp;count=4&amp;thumbnail_width=160&amp;show_titles=yes"></script>
    </div>
    <!-- END Vimeo Badge -->
    HTML
  end
  
  def openx_widget
    <<-EOL
    <!--/* OpenX Interstitial or Floating DHTML Tag v2.8.5-rc7 */-->
    <script type='text/javascript'><!--//<![CDATA[
       var ox_u = 'http://d1.openx.org/al.php?zoneid=14760&layerstyle=geocities&align=center&padding=2&closetext=%5BClose%5D&collapsetime=15';
       if (document.context) ox_u += '&context=' + escape(document.context);
       document.write("<scr"+"ipt type='text/javascript' src='" + ox_u + "'></scr"+"ipt>");
    //]]>--></script>
    EOL
  end
end