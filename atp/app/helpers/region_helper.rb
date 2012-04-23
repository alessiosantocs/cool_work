module RegionHelper
  include ImageSetHelper
  def cover_image_script(imgs)
    <<-EOL
    <script type="text/javascript" language="javascript">
    // <![CDATA[
    var imgAr = #{imgs.to_json};
    if (imgAr.length > 0 ){
      document.write("<img src='"+imgAr[Math.floor(Math.random()*imgAr.length)]+"' width='480' height='207' alt='Party On!' hspace='0' vspace='0' name='cover_image' id='cover_image' border='0' />");
    }
    // ]]>
    </script>
    EOL
  end

  def stat_image(stat)
    views = stat["views"]
    imgset = ImageSet.find(stat.obj_id, :include => [:image])
    event_image(imgset) << "<span>#{views} views <br /> #{event_image_set_link(imgset.obj)}</span>"
  end
  
  def region_list(splitter=" / ")
    list = []
    #get cities
    c = City.active.sort{|a,b| b.events_with_pics.to_i <=> a.events_with_pics.to_i }.inject([]) do |sum,city| 
      sum << [ city.events_with_pics.to_i, city.region.full_name, city.region.short_name]
    end
    #region
    c.map do |el|
      pic_count, city_name, region_short_name = el
      list << link_to(city_name, "http://#{region_short_name}.#{SITE.url}")
    end
    list.join(splitter)
  end
  
  def event_image_set_link(e)
    city_short_name = get_city_short_name(e.venue.city_id)
    txt = "#{city_short_name.upcase} > #{date_string(e.local_time)}: #{e.party.title} at #{e.venue.name}"
    link_to(txt, image_set_url(:host => "#{city_short_name}.#{SITE.url}", :obj_type => e.class.to_s.downcase, :obj_id => e.id), {:name => "event_#{e.id}", :class => "event_link"})
  end
  
  def site_photos(thumbnails=12)
    list = []
    # raise SITE.inspect
    events = Site.find(SITE_ID).events_with_pics
    #show thumbs
    events[0..thumbnails-1].each { |e| list << content_tag('li', event_thumbnail(e) << content_tag("span", event_image_set_link(e)), {:class => "with_thumb"}) } if (1..thumbnails).include?(events.size) or events.size > thumbnails - 1
    # show links
    events[thumbnails..-1].each { |e| list << content_tag('li', event_image_set_link(e) ) } if events.size > thumbnails
    # render list
    content_tag("ul", list, {:class=>'photos'})
  end
  
  def show_blog_feed(articles_shown=10)
    list = []
    blog = BlogFeed.new(FEED_XML, FEED_YAML_PATH, FEED_TTL)
    if blog.available?
      blog.data[:entries].each do |entry|
        list << { :title => entry[:title].maxlength(90), :date => entry[:date_published].time_ago, :link => entry[:link]}
      end
    end
    <<-EOL
    <div id='news'>AllTheParties Blog: <span id='news_clip'></span></div>
    <script type="text/javascript" language="javascript">
    // <![CDATA[
    function rotateNews() {
      var f = Feed[feedIndex];
      $W('news_clip', " <a href='" + f.link + "'>" + f.title + "</a> (" + f.date + ")");
      feedIndex++;
      if (feedIndex > Feed.length - 1){
        feedIndex = 0;
      }
    }
    var Feed = #{list.to_json};
    var feedIndex=0;
    rotateNews();
    new PeriodicalExecuter(rotateNews, 4);
    // ]]>
    </script>
    EOL
  end
end